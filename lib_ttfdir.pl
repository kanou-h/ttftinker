#!/usr/bin/env perl
# $Id: lib_ttfdir.pl,v 1.4 2003/08/05 16:26:37 s42335 Exp $
#
# lib_ttfdir.pl - ttf directory handling (used in ttf* tools)
#
#	2002/2, by 1@2ch
#	* public domain *
#

# ttf_readdir_from_ttf(): read a ttf directory from a file opened
# ttf_cat_type($type): dump a specified table in ttf file
# ttf_calc_sum($file): calc the sum of a table

# GLOBAL VARIABLES:
#  $ttf_is_ttc
#  $ttc_version
#  @ttc_ttfdirs
#
#  $ttf_font_type
#  $ttf_num_tables
#  $ttf_fontdir_types[]
#  $ttf_fontdir_sum{$type}
#  $ttf_fontdir_offset{$type}
#  $ttf_fontdir_length{$type}


require 'lib_util.pl';

sub ttf_readdir_from_ttf() {
    $t = rstr32();
    if ($t eq "ttcf") {
	# TTC file
	$ttf_is_ttc = 1;
	$ttc_version = ruint32();
	$ttc_num_ttfdirs = ruint32();
	@ttc_ttfdiroffsets = ();
	for(my $i=0; $i < $ttc_num_ttfdirs; $i++) {
	    push(@ttc_ttfdiroffsets, ruint32());
	}
	@ttc_ttfdirs = ();
	foreach my $offset (@ttc_ttfdiroffsets) {
	    rgoto($offset);
	    ttf_readdir_from_ttf_1();
	    local $font_type1 = $ttf_font_type;
	    local $num_tables1 = $ttf_num_tables;
	    local @fontdir_types1 = @ttf_fontdir_types;
	    local %fontdir_sum1 = %ttf_fontdir_sum;
	    local %fontdir_offset1 = %ttf_fontdir_offset;
	    local %fontdir_length1 = %ttf_fontdir_length;

	    push(@ttc_ttfdirs, [\$font_type1, \$num_tables1, \@fontdir_types1, 
				\%fontdir_sum1, \%fontdir_offset1, \%fontdir_length1]);
	}
    } else {
	$ttf_is_ttc = 0;
	ttf_readdir_from_ttf_1($t);
    }
}

# ttf_cd
sub ttf_cd($) {
    if (!$ttf_is_ttc) {
	die("not ttc file.");
    }
    my $x = $ttc_ttfdirs[$_[0]];
    $ttf_font_type = ${$x->[0]};
    $ttf_num_tables = ${$x->[1]};
    @ttf_fontdir_types = @{$x->[2]};
    %ttf_fontdir_num = %{$x->[3]};
    %ttf_fontdir_offset = %{$x->[4]};
    %ttf_fontdir_length = %{$x->[5]};
}
sub ttf_autocd($) {
    my $s = $_[0];
    if ($s =~ /^(\d+):(.+)$/) {
	ttf_cd($1);
	return $2;
    }
    return $s;
}

# ttf_readdir_from_ttf_1()
sub ttf_readdir_from_ttf_1($) {
    # read header
    $ttf_font_type = $_[0] || rstr32();

    $ttf_num_tables = ruint16();
    @ttf_fontdir_types = ();
    %ttf_fontdir_sum = ();
    %ttf_fontdir_offset = ();
    %ttf_fontdir_length = ();
    ruint16();	# searchRange
    ruint16();	# entrySelector
    ruint16();	# rangeShift

    # read directory
    for(my $i = 0; $i < $ttf_num_tables; $i++) {
	my $t = rstr32();
	push(@ttf_fontdir_types, $t);
	$ttf_fontdir_sum{$t}    = ruint32();
	$ttf_fontdir_offset{$t} = ruint32();
	$ttf_fontdir_length{$t} = ruint32();
    }
}

# ttf_cat_type($type)
sub ttf_cat_type($) {
    my $t = $_[0];
    if (! $ttf_fontdir_offset{$t}) { 
	err("not found: $t"); 
	return;
    }
    rgoto($ttf_fontdir_offset{$t});
    my $len = $ttf_fontdir_length{$t};
    while(0 < $len) {
	my $x = rstrn(($BUFSIZ < $len) ? $BUFSIZ : $len);
	$len -= length($x);
	wstrn($x);
    }
}

# ttf_calc_sum($file)
sub calc_sum($) {
    my $s = 0;
    my $x = $_[0];
    my $len = length($x);
    # padding to make the data length multiple of 4
    $x .= "\000" x (4-($len % 4)) if ($len % 4);
    for(my $i = 0; $i < length($x); $i += 4) {
	$s = addint($s, unpack('N', substr($x, $i, 4)));
    }
    $s;
}
sub ttf_calc_sum($) {
    ropen($_[0]);
    my $s = 0;
    while(my $x = rstrn($BUFSIZ)) {
	$s = addint($s, calc_sum($x));
    }
    rclose();
    $s;
}

1;
