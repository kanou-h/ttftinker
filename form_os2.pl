# $Id: form_os2.pl,v 1.3 2002/09/14 21:07:03 euske Exp $
# form_os2.pl (OS/2 table)
#
#	2002/2, by 1@2ch
#	* public domain *
#

define_form( <<'EOF'

uint16	version			# 0x0002
sint16	xAvgCharWidth		#
uint16	usWeightClass		#
uint16	usWidthClass		#
sint16	fsType
sint16	ySubscriptXSize
sint16	ySubscriptYSize
sint16	ySubscriptXOffset
sint16	ySubscriptYOffset
sint16	ySuperscriptXSize
sint16	ySuperscriptYSize
sint16	ySuperscriptXOffset
sint16	ySuperscriptYOffset
sint16	yStrikeoutSize
sint16	yStrikeoutPosition
sint16	sFamilyClass
uint8	panose0
uint8	panose1
uint8	panose2
uint8	panose3
uint8	panose4
uint8	panose5
uint8	panose6
uint8	panose7
uint8	panose8
uint8	panose9
uint32	ulUnicodeRange1		# Bits 0-31
uint32	ulUnicodeRange2		# Bits 32-63
uint32	ulUnicodeRange3		# Bits 64-95
uint32	ulUnicodeRange4		# Bits 96-127
str32	achVendID
uint16	fsSelection
uint16	usFirstCharIndex
uint16	usLastCharIndex
sint16	sTypoAscender
sint16	sTypoDescender
sint16	sTypoLineGap
uint16	usWinAscent
uint16	usWinDescent
uint32	ulCodePageRange1	# Bits 0-31
uint32	ulCodePageRange2	# Bits 32-63
#sint16	sxHeight
#sint16	sCapHeight
#uint16	usDefaultChar
#uint16	usBreakChar
#uint16	usMaxContext

EOF
);
