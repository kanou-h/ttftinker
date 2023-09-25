# $Id: form_head.pl,v 1.3 2002/09/14 21:07:03 euske Exp $
# form_head.pl (TTF HEADer)
#
#	2002/2, by 1@2ch
#	* public domain *
#

define_form( <<'EOF'

fixed	version			# 0x00010000 (version 1.0)
fixed	fontRevision		# set by font manufacturer
uint32	checkSumAdjustment
	# To compute: set it to 0, calculate the checksum for the 'head'
	# table and put it in the table directory, sum the entire font as
	# uint32, then store B1B0AFBA - sum. The checksum for the 'head'
	# table will not be wrong.  That is OK.
uint32	magicNumber		# set to 0x5F0F3CF5
bits16	flags			
	# bit 0 - y value of 0 specifies baseline
	# bit 1 - x position of left most black bit is LSB
	# bit 2 - scaled point size and actual point size will differ (i.e. 24 point glyph
	# differs from 12 point glyph scaled by factor of 2)
	# bit 3 - use integer scaling instead of fractional
	# bit 4 - (used by the Microsoft implementation of the TrueType scaler)
	# bit 5 - This bit should be set in fonts that are intended to e laid out
	# vertically, and in which the glyphs have been drawn such that an
	# x-coordinate of 0 corresponds to the desired vertical baseline.
	# bit 6 - This bit must be set to zero.
	# bit 7 - This bit should be set if the font requires layout for correct
	# linguistic rendering (e.g. Arabic fonts).
	# bit 8 - This bit should be set for a GX font which has one or more
	# metamorphosis effects designated as happening by default.
	# bit 9 - This bit should be set if the font contains any strong right-to-left
	# glyphs.
	# bit 10 - This bit should be set if the font contains Indic-style
	# rearrangement effects.
	# bits 11-12 - Defined by Adobe.
uint16	unitsPerEm		# range from 64 to 16384
uint64	created			# international date
uint64	modified		# international date
fword	xMin			# for all glyph bounding boxes
fword	yMin			# for all glyph bounding boxes
fword	xMax			# for all glyph bounding boxes
fword	yMax			# for all glyph bounding boxes
bits16	macStyle
	# bit 0 bold
	# bit 1 italic
	# bit 2 underline
	# bit 3 outline
	# bit 4 shadow
	# bit 5 condensed (narrow)
	# bit 6 extended
uint16	lowestRecPPEM		# smallest readable size in pixels
sint16	fontDirectionHint
	# 0 Mixed directional glyphs
	# 1 Only strongly left to right glyphs
	# 2 Like 1 but also contains neutrals
	# -1 Only strongly right to left glyphs
	# -2 Like -1 but also contains neutrals
sint16	indexToLocFormat	# 0 for short offsets, 1 for long
sint16	glyphDataFormat		# 0 for current format

EOF
);
