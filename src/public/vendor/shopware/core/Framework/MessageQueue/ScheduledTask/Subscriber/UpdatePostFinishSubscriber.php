<?php declare(strict_types=1);

namespace Shopware\Core\Framework\MessageQueue\ScheduledTask\Subscriber;

use Shopware\Core\Framework\MessageQueue\ScheduledTask\Registry\TaskRegistry;
use Shopware\Core\Framework\Update\Event\UpdatePostFinishEvent;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;

class UpdatePostFinishSubscriber implements EventSubscriberInterface
{
    private TaskRegistry $registry;

    public function __construct(TaskRegistry $taskRegistry)
    {
        $this->registry = $taskRegistry;
    }

    /**
     * @inheritDoc
     */
    public static function getSubscribedEvents(): array
    {
        return [UpdatePostFinishEvent::class => 'updatePostFinishEvent'];
    }

    public function updatePostFinishEvent(): void
    {
        $this->registry->registerTasks();
    }
}
