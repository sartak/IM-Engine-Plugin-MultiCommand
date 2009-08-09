package IM::Engine::Plugin::MultiCommand;
use Moose;
use Moose::Util::TypeConstraints;
use Scalar::Util 'weaken';
use List::Util 'first';
extends 'IM::Engine::Plugin';

our $VERSION = '0.01';

with 'IM::Engine::Plugin::Dispatcher::AugmentsDispatcher';

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

    my $weak_dispatcher_plugin = first { $_->isa('IM::Engine::Plugin::Dispatcher') } $self->engine->plugins;

    $dispatcher->unshift_rule(
        Path::Dispatcher::Rule::Regex->new(
            regex => qr{\s*\Q$separator\E\s*},
            block => sub {
                my $incoming = shift;
                my @commands = split /\s*\Q$separator\E\s*/, $_;

                return join "\n---\n", map {
                    my $message = $incoming->meta->clone_object(
                        $incoming,
                        plaintext => $_,
                    );

                    my $reply = $weak_dispatcher_plugin->incoming($message);
                    $reply ? $reply->plaintext : ''
                } @commands;
            },
        ),
    );

    weaken($weak_dispatcher_plugin);
}

1;

