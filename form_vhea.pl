# $Id: form_vhea.pl,v 1.3 2002/09/14 21:07:03 euske Exp $
# form_vhea.pl (Vertical metrics table HEAder)
#
#	2002/2, by 1@2ch
#	* public domain *
#

define_form( <<'EOF'

fixed	tableVersionNumber	# 0x00010000 (version 1.0)
fword	vertTypoAscender	# Typographic ascent.
fword	vertTypoDescender	# Typographic descent.
fword	vertTypoLinegap		# Typographic line gap.
ufword	advanceHeightMax	# Maximum advance width value in 'hmtx' table.
fword	minTopSideBearing	# Minimum top sidebearing value.
fword	minBottomSideBearing	# Minimum bottom sidebearing value.
fword	yMaxExtent		# Max(tsb + (yMax - yMin)).
sint16	caretSlopeRise		# Used to calculate the slope of the cursor (rise/run); 0 for horizontal.
sint16	caretSlopeRun		# 1 for horizontal.
sint16	caretOffset
	# The amount by which a slanted highlight on a glyph needs to be
	# shifted to produce the best appearance. Set to 0 for non-slanted
	# fonts.
sint16	reserved0		# set to 0
sint16	reserved1		# set to 0
sint16	reserved2		# set to 0
sint16	reserved3		# set to 0
sint16	metricDataFormat	# 0 for current format.
uint16	numberOfVMetrics	# Number of vMetric entries in 'vmtx' table

EOF
);
