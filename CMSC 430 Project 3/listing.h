// Omoniyi Tomjones
// CMSC 430: Computer Theory and Design
// Project 3
// Summer 2023

// This file contains the function prototypes for the functions that produce
// the compilation listing

enum ErrorCategories {LEXICAL, SYNTAX, GENERAL_SEMANTIC, DUPLICATE_IDENTIFIER,
	UNDECLARED};

void firstLine();
void nextLine();
int lastLine();
void appendError(ErrorCategories errorCategory, string message);

