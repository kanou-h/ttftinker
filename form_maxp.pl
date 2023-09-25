# $Id: form_maxp.pl,v 1.3 2002/09/14 21:07:03 euske Exp $
# form_maxp.pl (MAXimal Profile table)
#
#	2002/2, by 1@2ch
#	* public domain *
#

define_form( <<'EOF'

fixed	version			# 0x00010000 (1.0)
uint16	numGlyphs		# the number of glyphs in the font
uint16	maxPoints		# points in non-compound glyph
uint16	maxContours		# contours in non-compound glyph
uint16	maxComponentPoints	# points in compound glyph
uint16	maxComponentContours	# contours in compound glyph
uint16	maxZones		# set to 2
uint16	maxTwilightPoints	# points used in Twilight Zone (Z0)
uint16	maxStorage		# number of Storage Area locations
uint16	maxFunctionDefs		# number of FDEFs
uint16	maxInstructionDefs	# number of IDEFs
uint16	maxStackElements	# maximum stack depth
uint16	maxSizeOfInstructions	# byte count for glyph instructions
uint16	maxComponentElements	# number of glyphs referenced at top level
uint16	maxComponentDepth	# levels of recursion, set to 0 if font has only simple glyphs

EOF
);
