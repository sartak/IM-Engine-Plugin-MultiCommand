package IM::Engine::Plugin::MultiCommand;
use Moose;
use Moose::Util::TypeConstraints;
use Scalar::Util 'weaken';
use List::Util 'first';
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
    default  => sub { ';;' },
);

sub new_rules {} # satisfy requirement

sub augment_dispatcher {
    my $self       = shift;
    my $dispatcher = shift;
    my $separator  = $self->separator;

    # XXX: need to add unshift_rules to Path::Dispatcher :)

    my $weak_dispatcher_plugin = first { $_->isa('IM::Engine::Plugin::Dispatcher') } $self->engine->plugins;

    unshift @{ $dispatcher->{_rules} }, (
        Path::Dispatcher::Rule::Regex->new(
            regex => qr{^(.*?)\s*\Q$separator\E\s*(.*)$}sm,
            block => sub {
                my $incoming = shift;
                my $command = $incoming->meta->clone_object($incoming, plaintext => $1);
                my $rest    = $incoming->meta->clone_object($incoming, plaintext => $2);

                return (
                    $weak_dispatcher_plugin->incoming($command),
                    $weak_dispatcher_plugin->incoming($rest),
                );
            },
        ),
    );

    weaken($weak_dispatcher_plugin);
}

1;

