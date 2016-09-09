#!/usr/bin/env perl
# strip_patches.pl strips patches out of sequences
# and is released under the terms of the GNU GPL version 3, or any
# later version, at your option. See the file README and COPYING for
# more information.
# Copyright 2016 by Don Armstrong <don@donarmstrong.com>.


use warnings;
use strict;

use Getopt::Long;
use Pod::Usage;

=head1 NAME

strip_patches.pl - strips patches out of sequences

=head1 SYNOPSIS

strip_patches.pl [options]

 Options:
   --debug, -d debugging level (Default 0)
   --help, -h display this help
   --man, -m display manual

=head1 OPTIONS

=over

=item B<--debug, -d>

Debug verbosity. (Default 0)

=item B<--help, -h>

Display brief usage information.

=item B<--man, -m>

Display this manual.

=back

=head1 EXAMPLES

strip_patches.pl

=cut


use IO::File;
use vars qw($DEBUG);

my %options = (debug           => 0,
               help            => 0,
               man             => 0,
               valid_chr       => '^(?:chr)?[12]?\d|MT|[XY]$',
               gtf_chr_only    => 1,
              );

GetOptions(\%options,
           'gtf=s',
           'fasta=s',
           'fasta_out|fasta-out=s',
           'gtf_out|gtf-out=s',
           'gtf_chr_only|gtf-chr-only!',
           'valid_chr|valid-chr=s',
           'debug|d+','help|h|?','man|m');

pod2usage() if $options{help};
pod2usage({verbose=>2}) if $options{man};

$DEBUG = $options{debug};

my @USAGE_ERRORS;

for (qw(fasta fasta_out)) {
    if (not defined $options{$_}) {
        push @USAGE_ERRORS,"You must provide the '--$_' option";
    }
}

pod2usage(join("\n",@USAGE_ERRORS)) if @USAGE_ERRORS;


my %valid_chr;

if (not exists $options{gtf}) {
    $options{gtf_chr_only} = 0;
}

## read through and parse the gtf
if (exists $options{gtf}) {
    my $gtf = IO::File->new($options{gtf},'r') or
        die "Unable to open $options{gtf} for reading: $!";
    my $gtf_out;
    if (exists $options{gtf_out}) {
        $gtf_out = IO::File->new($options{gtf_out},'w') or
                die "Unable to open $options{gtf_out} for writing: $!";
    }
    while (<$gtf>) {
        if (/^#/) {
            print {$gtf_out} $_ if defined $gtf_out;
            next;
        }
        if (length $options{valid_chr} or $options{gtf_chr_only}) {
            my ($chr) = $_ =~ /^(\S+)/;
            if (length $options{valid_chr}) {
                next unless $chr =~ /$options{valid_chr}/;
            }
            $valid_chr{$chr} = 1;
        }
        print {$gtf_out} $_ if defined $gtf_out;
    }
    close($gtf_out) if exists $options{gtf_out};
    close($gtf);
}

my $fasta = IO::File->new($options{fasta},'r') or
    die "Unable to open $options{fasta} for reading: $!";
my $fasta_out = IO::File->new($options{fasta_out},'w') or
    die "Unable to open $options{fasta_out} for writing: $!";

my $output_current_fasta = 0;
while (<$fasta>) {
    if (/^>\s*(\S+)/) {
        my $chr = $1;
        print STDERR "chr is $chr\n";

        if ($options{gtf_chr_only} and not exists $valid_chr{$chr}) {
            $output_current_fasta = 0;
            next;
        }
        if (length $options{valid_chr}) {
            if ($chr =~ /$options{valid_chr}/) {
                $output_current_fasta = 1;
            } else {
                $output_current_fasta = 0;
            }
        } else {
           $output_current_fasta = 1;
        }

    }
    next unless $output_current_fasta;
    print {$fasta_out} $_;
}

__END__
