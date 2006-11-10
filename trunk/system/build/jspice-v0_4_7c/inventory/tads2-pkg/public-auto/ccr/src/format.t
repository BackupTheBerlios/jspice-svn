/*
 * Formatting commands
 */

/*
 * End of paragraph
 */
P: function
{
	if (global.doublespace)
		"\b";
	else
		"\n";
}

/*
 * Indent
 */
I: function
{
	if (global.indent)
		"\t";
}
