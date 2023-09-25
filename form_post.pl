# $Id: form_post.pl,v 1.3 2002/09/14 21:07:03 euske Exp $
# form_post.pl (POSTscript)
#
#	2002/2, by 1@2ch
#	* public domain *
#

define_form( <<'EOF'

fixed	version			# 0x00010000 for version 1.0
fixed	italicAngle		# Italic angle in counter-clockwise degrees
	# from the vertical. Zero for upright text, 
	# negative for text that leans to the right (forward)
fword	underlinePosition	# the suggested distance 
	# of the top of the underline from the baseline
	# (negative values indicate below baseline).
	# The PostScript definition of this FontInfo dictionary key (the y
	# coordinate of the center of the stroke) is not used for historical
	# reasons. The value of the PostScript key may be calculated by
	# subtracting half the underlineThickness from the value of this
	# field.
fword	underlineThickness	# Suggested values for the underline thickness.
uint32	isFixedPitch		# Set to 0 if the font is proportionally
	# spaced, non-zero if the font is not proportionally 
	# spaced (i.e. monospaced).
uint32	minMemType42		# Minimum memory usage 
	# when an OpenType font is downloaded.
uint32	maxMemType42		# Maximum memory usage
	# when an OpenType font is downloaded.
uint32	minMemType1		# Minimum memory usage
	# when an OpenType font is downloaded as a Type 1 font.
uint32	maxMemType1		# Maximum memory usage
	# when an OpenType font is downloaded as a Type 1 font.

EOF
);
