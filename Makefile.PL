use inc::Module::Install;

name     'IM-Engine-Plugin-MultiCommand';
all_from 'lib/IM/Engine/Plugin/MultiCommand.pm';
githubmeta;

requires 'Moose';

requires 'IM::Engine' => 0.03;
requires 'IM::Engine::Plugin::Dispatcher' => 0.02;

tests('t/*.t t/*/*.t');

auto_install;
WriteAll;

