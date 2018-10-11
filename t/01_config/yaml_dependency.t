use Test::More tests => 2;
use strict;
use warnings;

use Dancer::Config;
use Dancer::ModuleLoader;

use File::Spec;
use lib File::Spec->catdir( 't', 'lib' );
use EasyMocker;

mock 'Dancer::Config'
    => method 'conffile'
    => should sub { __FILE__ };

mock 'Dancer::ModuleLoader'
    => method 'load'
    => should sub { 0, "Fish error. Goldfish in YAML." };

eval { Dancer::Config->load };
like $@, qr/Could not load YAML: Fish error. Goldfish in YAML./,
    "Dancer::Config cannot load without YAML";

unmock 'Dancer::ModuleLoader' => method 'load';

mock 'YAML'
    => method 'LoadFile'
    => should sub { undef };
eval { Dancer::Config::load_settings_from_yaml('foo.yml') };
like $@, qr/Unable to parse the configuration file: foo.yml/, "YAML error caught";

