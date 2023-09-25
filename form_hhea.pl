# $Id: form_hhea.pl,v 1.3 2002/09/14 21:07:03 euske Exp $
# form_hhea.pl (Horizontal metrics table HEAder)
#
#	2002/2, by 1@2ch
#	* public domain *
#

define_form( <<'EOF'

fixed	tableVersionNumber	# 0x00010000 (version 1.0)
fword	ascender		# Typographic ascent.
fword	descender		# Typographic descent.
fword	linegap			# Typographic line gap.
	# Negative LineGap values are
	# treated as zero in Windows 3.1,
	# System 6, and System 7.
ufword	advanceWidthMax		# Maximum advance width value in 'hmtx' table.
fword	minLeftSideBearing	# Minimum left sidebearing value in 'hmtx' table.
fword	minRightSideBearing	# Minimum right sidebearing value;
	# calculated as Min(aw - lsb - (xMax - xMin)).
fword	xMaxExtent		# Max(lsb + (xMax - xMin)).
sint16	caretSlopeRise		# Used to calculate the slope of the cursor (rise/run); 1 for vertical.
sint16	caretSlopeRun		# 0 for vertical.
sint16	caretOffset
	# The amount by which a slanted highlight on a glyph needs to be
	# shifted to produce the best appearance. Set to 0 for non-slanted
	# fonts.
sint16	reserved0		# set to 0
sint16	reserved1		# set to 0
sint16	reserved2		# set to 0
sint16	reserved3		# set to 0
sint16	metricDataFormat	# 0 for current format.
uint16	numberOfHMetrics	# Number of hMetric entries in 'hmtx' table

EOF
);
