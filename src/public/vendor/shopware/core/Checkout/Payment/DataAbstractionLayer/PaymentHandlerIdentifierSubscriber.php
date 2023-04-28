<?php declare(strict_types=1);

namespace Shopware\Core\Checkout\Payment\DataAbstractionLayer;

use Shopware\Core\Checkout\Payment\Cart\PaymentHandler\AsynchronousPaymentHandlerInterface;
use Shopware\Core\Checkout\Payment\Cart\PaymentHandler\PreparedPaymentHandlerInterface;
use Shopware\Core\Checkout\Payment\Cart\PaymentHandler\SynchronousPaymentHandlerInterface;
use Shopware\Core\Checkout\Payment\PaymentEvents;
use Shopware\Core\Checkout\Payment\PaymentMethodEntity;
use Shopware\Core\Framework\DataAbstractionLayer\Event\EntityLoadedEvent;
use Shopware\Core\Framework\Feature;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\Serializer\NameConverter\CamelCaseToSnakeCaseNameConverter;

class PaymentHandlerIdentifierSubscriber implements EventSubscriberInterface
{
    public static function getSubscribedEvents(): array
    {
        return [
            PaymentEvents::PAYMENT_METHOD_LOADED_EVENT => 'formatHandlerIdentifier',
        ];
    }

    public function formatHandlerIdentifier(EntityLoadedEvent $event): void
    {
        /** @var PaymentMethodEntity $entity */
        foreach ($event->getEntities() as $entity) {
            if (Feature::isActive('FEATURE_NEXT_16769')) {
                $this->setPaymentMethodHandlerRuntimeFields($entity);
            }

            $explodedHandlerIdentifier = explode('\\', $entity->getHandlerIdentifier());

            $last = $explodedHandlerIdentifier[\count($explodedHandlerIdentifier) - 1];
            $entity->setShortName((new CamelCaseToSnakeCaseNameConverter())->normalize($last));

            if (\count($explodedHandlerIdentifier) < 2) {
                $entity->setFormattedHandlerIdentifier($entity->getHandlerIdentifier());

                continue;
            }

            /** @var string|null $firstHandlerIdentifier */
            $firstHandlerIdentifier = array_shift($explodedHandlerIdentifier);
            $lastHandlerIdentifier = array_pop($explodedHandlerIdentifier);
            if ($firstHandlerIdentifier === null || $lastHandlerIdentifier === null) {
                continue;
            }

            $formattedHandlerIdentifier = 'handler_'
                . mb_strtolower($firstHandlerIdentifier)
                . '_'
                . mb_strtolower($lastHandlerIdentifier);

            $entity->setFormattedHandlerIdentifier($formattedHandlerIdentifier);
        }
    }

    private function setPaymentMethodHandlerRuntimeFields(PaymentMethodEntity $entity): void
    {
        $handlerIdentifier = $entity->getHandlerIdentifier();

        if (\is_a($handlerIdentifier, SynchronousPaymentHandlerInterface::class, true)) {
            $entity->setSynchronous(true);
        }

        if (\is_a($handlerIdentifier, AsynchronousPaymentHandlerInterface::class, true)) {
            $entity->setAsynchronous(true);
        }

        if (\is_a($handlerIdentifier, PreparedPaymentHandlerInterface::class, true)) {
            $entity->setPrepared(true);
        }
    }
}
