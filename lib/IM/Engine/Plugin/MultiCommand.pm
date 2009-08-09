package IM::Engine::Plugin::MultiCommand;
use Moose;
use Moose::Util::TypeConstraints;
extends 'IM::Engine::Plugin';

our $VERSION = '0.01';

with (
    'IM::Engine::RequiresPlugins' => {
        plugins => 'IM::Engine::Plugin::Dispatcher',
    },
    'IM::Engine::Plugin::Dispatcher::AugmentsDispatcher',
);

has separator => (
    is       => 'ro',
    isa      => 'Str',
    default  => sub { ';;' }
);

1;

