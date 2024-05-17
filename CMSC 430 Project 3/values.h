// Omoniyi Tomjones
// CMSC 430: Computer Theory and Design
// Project 3
// Summer 2023

// This file contains type definitions and the function
// definitions for the evaluation functions

typedef char* CharPtr;

enum Operators {ADD, MULTIPLY, LESS, AND, SUBTRACT, DIVIDE, PERCENT, NOT, OR, POWER, GREATER, NOTEQUAL, GREATEREQUAL, EQUAL};

double evaluateArithmetic(double left, Operators operator_, double right);
double evaluateRelational(double left, Operators operator_, double right);
double evaluateFold(double left, double right, bool leftFold);

enum Types {MISMATCH, INT_TYPE, CHAR_TYPE, NONE};

void checkAssignment(Types lValue, Types rValue, string message);
Types checkWhen(Types true_, Types false_);
Types checkSwitch(Types case_, Types when, Types other);
Types checkCases(Types left, Types right);
Types checkArithmetic(Types left, Types right);
