// Omoniyi Tomjones
// CMSC 430: Computer Theory and Design
// Project 3
// Summer 2023

// This file contains the bodies of the evaluation functions

#include <string>
#include <cmath>

using namespace std;

#include "values.h"
#include "listing.h"

double evaluateArithmetic(double left, Operators operator_, double right) {
	double result;
	switch (operator_) {
		case ADD:
			result = left + right;
			break;
		case MULTIPLY:
			result = left * right;
			break;
		case SUBTRACT:
			result = left - right;
			break;
		case DIVIDE:
			result = left / right;
			break;
		case POWER:
			result = pow(left, right);
			break;
		case PERCENT:
			result = left;
			break;
	}
	return result;
}

double evaluateRelational(double left, Operators operator_, double right) {
	double result;
	switch (operator_) {
		case LESS:
			result = left < right;
			break;
		case GREATER:
			result = left > right;
			break;
		case NOTEQUAL:
			result = left != right;
			break;
		case GREATEREQUAL:
			result = left >= right;
			break;
		case EQUAL:
			result = left == right;
			break;
		case NOT:
		    result = !left;
    		break;
		case OR:
			result = left || right;
			break;
		default:
			result = 0;
			break;
	}
	return result;
}

double evaluateFold(double left, double right, bool leftFold) {
    return leftFold ? right - left : left - right;
}