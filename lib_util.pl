#!/usr/bin/env perl
# $Id: lib_util.pl,v 1.3 2002/09/14 21:07:03 euske Exp $
#
# lib_util.pl - misc. utilities
#
#	2002/2, by 1@2ch
#	* public domain *
#

# binary file operation

# read
#  wuint8($x);
#  wsint8($x);
#  wuint16($x);
#  wsint16($x);
#  wuint24($x);
#  wuint32($x);
#  wstr32($x);
#  wstrn($x);
#  wgoto($pos);
#  wpos();

# write
#  ruint8();
#  rsint8();
#  ruint16();
#  rsint16();
#  ruint24();
#  ruint32();
#  rstr32();
#  rstrn($len);
#  rgoto($pos);
#  rpos();
#  rpos_push();
#  rpos_pop();

# convert to string
#  suint8();
#  ssint8();
#  suint16();
#  ssint16();
#  suint24();
#  suint32();
#  sstr32();

# 32bit ulong add/subtr
#  addint($x,$y);
#  subint($x,$y);

# get a line skipping comments
#  getline(HANDLE);


$BUFSIZ = 1024;

$WPOS = 0;
$RPOS = 0;
@RPOS_STACK = ();

sub wopen($) {
    $W_FILE=$_[0];
    open(BINOUT, ">$W_FILE") || die("wopen: $W_FILE: $!");
    binmode(BINOUT);
}
sub wclose() {
    close(BINOUT);
}

sub wuint8($) {
    syswrite(BINOUT, pack('C', $_[0]), 1) || &werr();
    $WPOS += 1;
}
sub wsint8($) {
    $_[0] += 256 if ($_[0] < 0);
    syswrite(BINOUT, pack('C', $_[0]), 1) || &werr();
    $WPOS += 1;
}
sub wuint16($) {
    syswrite(BINOUT, pack('n', $_[0]), 2) || &werr();
    $WPOS += 2;
}
sub wsint16($) {
    $_[0] += 65536 if ($_[0] < 0);
    syswrite(BINOUT, pack('n', $_[0]), 2) || &werr();
    $WPOS += 2;
}
sub wuint24($) { 
    syswrite(BINOUT, substr(pack('N', $_[0]),1), 3) || &werr();
    $WPOS += 3;
}
sub wuint32($) {
    syswrite(BINOUT, pack('N', $_[0]), 4) || &werr();
    $WPOS += 4;
}
sub wstr32($) {
    syswrite(BINOUT, $_[0], 4) || &werr();
    $WPOS += 4;
}
sub wstrn($) {
    (syswrite(BINOUT, $_[0], length($_[0])) == length($_[0])) || &werr();
    $WPOS += length($_[0]);
}
sub wgoto($) {
    die("illegal seek: $_[0] < $WPOS") if ($_[0] < $WPOS);
    my $len = $_[0] - $WPOS;
    (syswrite(BINOUT, "\000" x $len, $len) == $len) || &werr();
    $WPOS = $_[0]; 
}
sub wpos() { $WPOS; }

sub ropen($) {
    $R_FILE=$_[0];
    open(BININ, $R_FILE) || die("ropen: $R_FILE: $!");
    binmode(BININ);
}
sub rclose() {
    close(BININ);
}

sub ruint8() {
    sysread(BININ, $_, 1) || &rerr();
    $RPOS += 1;
    unpack('C', $_);
}
sub rsint8() {
    sysread(BININ, $_, 1) || &rerr();
    $RPOS += 1;
    my $x = unpack('C', $_);
    if (128 <= $x) { $x - 256; } else { $x; }
}
sub ruint16() {
    sysread(BININ, $_, 2) || &rerr(); 
    $RPOS += 2;
    unpack('n', $_);
}
sub rsint16() {
    sysread(BININ, $_, 2) || &rerr(); 
    $RPOS += 2;
    my $x = unpack('n', $_);
    if (32768 <= $x) { $x - 65536; } else { $x; }
}
sub ruint24() { 
    sysread(BININ, $_, 3) || &rerr(); 
    $RPOS += 3;
    unpack('N', "\000" . $_);
}
sub ruint32() {
    sysread(BININ, $_, 4) || &rerr(); 
    $RPOS += 4;
    unpack('N', $_);
}
sub rstr32() { 
    sysread(BININ, $_, 4) || &rerr(); 
    $RPOS += 4;
    $_; 
}
sub rstrn($) { 
    my $len = $_[0];
    (0 <= sysread(BININ, $_, $len)) || &rerr(); 
    $RPOS += $len;
    $_;
}
sub rgoto($) {
    sysseek(BININ, $_[0], 0) || die("sysseek: $_[0]: $!");
    $RPOS = $_[0];
}
sub rpos() { $RPOS; }
sub rpos_push() {
    push(@RPOS_STACK, $RPOS); 
}
sub rpos_pop() {
    &rgoto(pop(@RPOS_STACK)); 
}

sub suint8($) {
    pack('C', $_[0]);
}
sub ssint8($) {
    $_[0] += 256 if ($_[0] < 0);
    pack('C', $_[0]);
}
sub suint16($) {
    pack('n', $_[0]);
}
sub ssint16($) {
    $_[0] += 65536 if ($_[0] < 0);
    pack('n', $_[0]);
}
sub suint24($) { 
    substr(pack('N', $_[0]), 1);
}
sub suint32($) {
    pack('N', $_[0]);
}
sub sstr32($) {
    substr($_[0] . '    ', 0, 4);
}

sub err($) { print STDERR "$0: $_[0]\n"; }
sub rerr() { die("sysread: $R_FILE($RPOS): $!"); }
sub werr() { die("syswrite: $W_FILE($WPOS): $!"); }

sub addint($$) {
    my $x = ($_[0] & 0xffff) + ($_[1] & 0xffff);
    my $y = ($_[0] >> 16) + ($_[1] >> 16) + (0x10000 <= $x);
    ((($y & 0xffff) << 16) | ($x & 0xffff));
}

sub subint($$) {
    my $x = ($_[0] & 0xffff | 0x10000) - ($_[1] & 0xffff);
    my $y = (($_[0] >> 16) | 0x10000) - ($_[1] >> 16) - ($x < 0x10000);
    ((($y & 0xffff) << 16) | ($x & 0xffff));
}

sub getline(*) {
    my $h = $_[0];
    do {
	$_ = <$h>;
	return $_ if (!$_);
	chop;
	s/\#.*$//;
    } while(/^\s*$/);
    $_;
}

1;
