use 5.006;
use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::Compile 2.054

use Test::More;

plan tests => 29 + ($ENV{AUTHOR_TESTING} ? 1 : 0);

my @module_files = (
    'App/Prove/Elasticsearch/Blamer/Default.pm',
    'App/Prove/Elasticsearch/Blamer/Env.pm',
    'App/Prove/Elasticsearch/Blamer/Git.pm',
    'App/Prove/Elasticsearch/Blamer/System.pm',
    'App/Prove/Elasticsearch/Harness.pm',
    'App/Prove/Elasticsearch/Indexer.pm',
    'App/Prove/Elasticsearch/Indexer/DzilDist.pm',
    'App/Prove/Elasticsearch/Indexer/MMDist.pm',
    'App/Prove/Elasticsearch/Parser.pm',
    'App/Prove/Elasticsearch/Planner/Default.pm',
    'App/Prove/Elasticsearch/Platformer/Default.pm',
    'App/Prove/Elasticsearch/Platformer/Env.pm',
    'App/Prove/Elasticsearch/Provisioner/Git.pm',
    'App/Prove/Elasticsearch/Provisioner/Perl.pm',
    'App/Prove/Elasticsearch/Queue/Default.pm',
    'App/Prove/Elasticsearch/Queue/Rabbit.pm',
    'App/Prove/Elasticsearch/Runner/Default.pm',
    'App/Prove/Elasticsearch/Searcher/ByName.pm',
    'App/Prove/Elasticsearch/Utils.pm',
    'App/Prove/Elasticsearch/Versioner/Default.pm',
    'App/Prove/Elasticsearch/Versioner/Env.pm',
    'App/Prove/Elasticsearch/Versioner/Git.pm',
    'App/Prove/Plugin/Elasticsearch.pm',
    'App/ape.pm',
    'App/ape/plan.pm',
    'App/ape/test.pm',
    'App/ape/update.pm'
);

my @scripts = (
    'bin/ape',
    'bin/testd'
);

# no fake home requested

my $inc_switch = -d 'blib' ? '-Mblib' : '-Ilib';

use File::Spec;
use IPC::Open3;
use IO::Handle;

open my $stdin, '<', File::Spec->devnull or die "can't open devnull: $!";

my @warnings;
for my $lib (@module_files)
{
    # see L<perlfaq8/How can I capture STDERR from an external command?>
    my $stderr = IO::Handle->new;

    my $pid = open3($stdin, '>&STDERR', $stderr, $^X, $inc_switch, '-e', "require q[$lib]");
    binmode $stderr, ':crlf' if $^O eq 'MSWin32';
    my @_warnings = <$stderr>;
    waitpid($pid, 0);
    is($?, 0, "$lib loaded ok");

    shift @_warnings if @_warnings and $_warnings[0] =~ /^Using .*\bblib/
        and not eval { require blib; blib->VERSION('1.01') };

    if (@_warnings)
    {
        warn @_warnings;
        push @warnings, @_warnings;
    }
}

foreach my $file (@scripts)
{ SKIP: {
    open my $fh, '<', $file or warn("Unable to open $file: $!"), next;
    my $line = <$fh>;

    close $fh and skip("$file isn't perl", 1) unless $line =~ /^#!\s*(?:\S*perl\S*)((?:\s+-\w*)*)(?:\s*#.*)?$/;
    my @flags = $1 ? split(' ', $1) : ();

    my $stderr = IO::Handle->new;

    my $pid = open3($stdin, '>&STDERR', $stderr, $^X, $inc_switch, @flags, '-c', $file);
    binmode $stderr, ':crlf' if $^O eq 'MSWin32';
    my @_warnings = <$stderr>;
    waitpid($pid, 0);
    is($?, 0, "$file compiled ok");

    shift @_warnings if @_warnings and $_warnings[0] =~ /^Using .*\bblib/
        and not eval { require blib; blib->VERSION('1.01') };

    # in older perls, -c output is simply the file portion of the path being tested
    if (@_warnings = grep { !/\bsyntax OK$/ }
        grep { chomp; $_ ne (File::Spec->splitpath($file))[2] } @_warnings)
    {
        warn @_warnings;
        push @warnings, @_warnings;
    }
} }



is(scalar(@warnings), 0, 'no warnings found')
    or diag 'got warnings: ', ( Test::More->can('explain') ? Test::More::explain(\@warnings) : join("\n", '', @warnings) ) if $ENV{AUTHOR_TESTING};

