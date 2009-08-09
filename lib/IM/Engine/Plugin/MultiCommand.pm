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

sub new_rules {} # satisfy requirement

sub augment_dispatcher {
    my $self       = shift;
    my $dispatcher = shift;
    my $separator  = $self->separator;

    # XXX: need to add unshift_rules to Path::Dispatcher :)

    unshift @{ $dispatcher->{rules} }, (
        Path::Dispatcher::Rule::Regex->new(
            regex => qr/(.*?)\s*\Q$separator\E\s*(.*)/,
            block => sub {
                warn "$1";
                warn "$2";
            },
        ),
    );
}

1;

