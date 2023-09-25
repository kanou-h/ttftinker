#!/usr/bin/env perl
# $Id: lib_form.pl,v 1.3 2002/09/14 21:07:03 euske Exp $
#
# lib_form.pl - form handling (form_*.pl)
#
#	2002/2, by 1@2ch
#	* public domain *
#

# define_form($): construct a form a given text.
# disp_form(@args): display the form (used in disp_* tools)
# make_form($file, @args): dump the form (used in make_* tools)


require 'lib_util.pl';

sub define_form($) {
    foreach $_ (split("\n", $_[0])) {
	my $c;
	$c = $1 if (s/(\#.*)$//);
	split(/\s+/);
	if (2 <= @_) {
	    push(@form_fields, $_[1]);
	    push(@form_comments, $c);
	    $_[1] =~ tr/A-Z/a-z/;
	    $form_types{$_[1]} = $_[0];
	}
    }
    1;
}

sub disp_form(@) {
    my $ff = shift(@_);
    ropen($ff);
    %form_val = ();
    for(my $i = 0; $i < @form_fields; $i++) {
	my $f = $form_fields[$i];
	$f =~ tr/A-Z/a-z/;
	my $t = $form_types{$f};
	my $v;
	if ($t eq 'uint8') {
	    $v = ruint8();
	} elsif ($t eq 'uint16' || $t eq 'ufword') {
	    $v =  ruint16();
	} elsif ($t eq 'sint16' || $t eq 'fword') {
	    $v = rsint16();
	} elsif ($t eq 'bits16') {
	    $v = sprintf("0x%04lx", ruint16());
	} elsif ($t eq 'uint32' || $t eq 'fixed') {
	    $v = sprintf("0x%08lx", ruint32());
	} elsif ($t eq 'str32') {
	    $v = rstr32();
	} elsif ($t eq 'uint64') {
	    $v = sprintf("0x%08lx 0x%08lx", ruint32(), ruint32());
	} else {
	    print STDERR "disp_form: unknown type: $f ($t)\n";
	}
	$form_val{$f} = $v;
    }
    if (0 == @_) {
	for(my $i = 0; $i < @form_fields; $i++) {
	    my $f = $form_fields[$i];
	    $f =~ tr/A-Z/a-z/;
	    print "$form_fields[$i]\t$form_val{$f}\t$form_comments[$i]\n";
	}
    } else {
	foreach my $f (@_) {
	    $f =~ tr/A-Z/a-z/;
	    print $form_val{$f},"\n";
	}
    }
    rclose();
}

sub make_field1(@) {
    my ($f, $arg1, $arg2) = @_;
    $f =~ tr/A-Z/a-z/;
    my $t = $form_types{$f};
    #print "$f, $t, $arg1\n";
    if ($t eq 'uint8') {
	$form_val{$f} = pack('C', eval($arg1));
    } elsif ($t eq 'uint16' || $t eq 'ufword') {
	$form_val{$f} = substr(pack('n', eval($arg1)), 0, 2);
    } elsif ($t eq 'sint16' || $t eq 'fword' || $t eq 'bits16') {
	$arg1 += 65536 if ($arg1 < 0);
	$form_val{$f} = substr(pack('n', eval($arg1)), 0, 2);
    } elsif ($t eq 'uint32' || $t eq 'fixed') {
	$form_val{$f} = pack('N', eval($arg1));
    } elsif ($t eq 'str32') {
	$form_val{$f} = substr($arg1, 0, 4);
    } elsif ($t eq 'uint64') {
	$form_val{$f} = pack('N', eval($arg1)) . pack('N', eval($arg2));
    } else {
	print STDERR "make_form: warining: unknown type: $f ($t)\n";
    }
}

sub make_form($@) {
    my $ff = shift(@_);
    @extra = @_;
    open(IN, $ff) || die("open: $ff: $!");
    %form_val = ();
    while($_ = getline(IN)) {
	split(/\s+/);
	next if (@_ < 2);
	make_field1(@_);
    }
    close(IN);
    foreach my $x (@extra) {
	$x =~ /^(\w+)=(.+)$/;
	@args = split(/\s+/, $2);
	make_field1($1, @args);
    }
    foreach my $f (@form_fields) {
	$f =~ tr/A-Z/a-z/;
	die "make_form: $ff: '$f' lacks" if ($form_val{$f} eq '');
    }
    wopen('&STDOUT');
    foreach my $f (@form_fields) {
	wstrn($form_val{$f});
    }    
    wclose();
}

1;
