#!/usr/bin/env perl
# $Id: lib_metric.pl,v 1.3 2002/09/14 21:07:03 euske Exp $
#
# lib_metric.pl - metrics handling (used mainly in EBLC, EBDT operation)
#
#	2002/2, by 1@2ch
#	* public domain *
#

# rsbitLineMetrics:	read sbitLineMetrics
# wsbitLineMetrics:	write sbitLineMetrics
# dispsbitLineMetrics:	display sbitLineMetrics
# rbigGlyphMetrics:	read bigGlyphMetrics
# wbigGlyphMetrics:	write bigGlyphMetrics
# strBigGlyphMetrics:	convert bigGlyphMetrics to string expr
# bdfBigGlyphMetrics:	display bigGlyphMetrics in bdf-like format
# rsmallGlyphMetrics:	read smallGlyphMetrics
# wsmallGlyphMetrics:	write smallGlyphMetrics
# strSmallGlyphMetrics:	convert smallGlyphMetrics to string expr
# bdfSmallGlyphMetrics:	display smallGlyphMetrics in bdf-like format


# bitLineMetrics: 12bytes
# bigGlyphMetrics: 8bytes
# smallGlyphMetrics: 5bytes


require 'lib_util.pl';

sub rsbitLineMetrics(@) {
    my $ascender = rsint8();
    my $descender = rsint8();
    my $widthMax = ruint8();
    my $caretSlopeNumerator = rsint8();
    my $caretSlopeDemominator = rsint8();
    my $caretOffset = rsint8();
    my $minOriginSB = rsint8();
    my $minAdvanceSB = rsint8();
    my $maxBeforeBL = rsint8();
    my $minAfterBL = rsint8();
    ruint16();
    
    ($ascender, $descender, $widthMax, $caretSlopeNumerator,
     $caretSlopeDemominator, $caretOffset, 
     $minOriginSB, $minAdvanceSB, $maxBeforeBL, $minAfterBL);
}

sub wsbitLineMetrics(@) {
    my ($ascender, $descender, $widthMax, $caretSlopeNumerator,
	$caretSlopeDemominator, $caretOffset, 
	$minOriginSB, $minAdvanceSB, $maxBeforeBL, $minAfterBL) = @_;

    wsint8($ascender);
    wsint8($descender);
    wuint8($widthMax);
    wsint8($caretSlopeNumerator);
    wsint8($caretSlopeDemominator);
    wsint8($caretOffset);
    wsint8($minOriginSB);
    wsint8($minAdvanceSB);
    wsint8($maxBeforeBL);
    wsint8($minAfterBL);
    wuint16(0);
}

sub dispsbitLineMetrics(@) {
    my ($s, $ascender, $descender, $widthMax, $caretSlopeNumerator,
	$caretSlopeDemominator, $caretOffset, 
	$minOriginSB, $minAdvanceSB, $maxBeforeBL, $minAfterBL) = @_;
    
    print $s, "ascender:     $ascender\n";
    print $s, "descender:    $descender\n";
    print $s, "widthMax:     $widthMax\n";
    print $s, "calet:        $caretSlopeNumerator/$caretSlopeDemominator, +$caretOffset\n";
    print $s, "minOriginSB:  $minOriginSB\n";
    print $s, "minAdvanceSB: $minAdvanceSB\n";
    print $s, "maxBeforeBL:  $maxBeforeBL\n";
    print $s, "minAfterBL:   $minAfterBL\n";
}


sub rbigGlyphMetrics() {
    my $h = ruint8();
    my $w = ruint8();
    my $hbx = rsint8();
    my $hby = rsint8();
    my $had = ruint8();
    my $vbx = rsint8();
    my $vby = rsint8();
    my $vad = ruint8();
    ($h, $w, $hbx, $hby, $had, $vbx, $vby, $vad);
}

sub wbigGlyphMetrics($$$$$$$$) {
    ($bh, $bw, $hbx, $hby, $had, $vbx, $vby, $vad) = @_;
    &wuint8($bh);
    &wuint8($bw);
    &wsint8($hbx);
    &wsint8($hby);
    &wuint8($had);
    &wsint8($vbx);
    &wsint8($vby);
    &wuint8($vad);
}

sub strBigGlyphMetrics(@) {
    return sprintf("%dx%d hx:%d hy:%d ha:%d vx:%d vy:%d va:%d", @_);
}

sub bdfBigGlyphMetrics(@) {
    ($bh, $bw, $hbx, $hby, $had, $vbx, $vby, $vad) = @_;
    printf "COMMENT METRIC %dx%d hx:%d hy:%d ha:%d vx:%d vy:%d va:%d\n", @_;
    printf "DWIDTH %d %d\n", $had, 0;
    printf "BBX %d %d %d %d\n", $bw, $bh, $hbx, $hby-$bh;
}


sub rsmallGlyphMetrics() {
    my $h = ruint8();
    my $w = ruint8();
    my $bx = rsint8();
    my $by = rsint8();
    my $ad = ruint8();
    ($h, $w, $bx, $by, $ad);
}

sub wsmallGlyphMetrics($$$$$) {
    ($bh, $bw, $hbx, $hby, $had) = @_;
    &wuint8($bh);
    &wuint8($bw);
    &wsint8($hbx);
    &wsint8($hby);
    &wuint8($had);
}

sub strSmallGlyphMetrics(@) {
    return sprintf("%dx%d x:%d y:%d a:%d", @_);
}

sub bdfSmallGlyphMetrics(@) {
    ($bh, $bw, $hbx, $hby, $had) = @_;
    printf "DWIDTH %d %d\n", $had, 0;
    printf "BBX    %d %d %d %d\n", $bw, $bh, $hbx-$bw, $hby-$bh;
}

1;
