#!/usr/bin/env perl

use strict;
use warnings;

use Carp;
use File::Find::Rule;
use File::Basename;

my ($path) = @ARGV;

if (not defined $path) {
    my ($name, $p, $extension) = fileparse($0, qr{\.[^.]*$});
    die "Path is required!\n\nUSAGE: $name$extension [path]\n";
}

my @files = File::Find::Rule->file()->name('*.php')->in($path);

for my $file (@files) {
    print "Processing $file\n";
    rename $file, $file.'.orig';
    open my $output, '>', $file or Carp::croak("Write Error with $file $! $@ ");
    open my $input, '<', $file.'.orig'
        or Carp::croak("Read error with $file.orig $! $@");

    while (my $line = <$input>) {
        # Replace <?= with <?php echo
        $line =~ s/<\?=/<?php echo /g;

        # Replace <? with <?php
        $line =~ s/<\?(?!php|xml)/<?php /g;
        print $output $line;
    }

    close $input or Carp::carp(" Close error with $file.orig, $! $@");
    close $output or Carp::carp(" Close error with $file  , $! $@");

    unlink $file.'.orig';
}