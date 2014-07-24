# Parsor

A Parser, written in Ruby. Its purpose is creating Matlabfunctions from Rapidminer results.

## works for following RapidMiner Modules
* Linear Regression Analysis
* Polynomial Regression Analysis
* M5-Tree Weka Analysis
* M5-Rules Weka Analysis

## folder structure
* anleitung -> the documentation of parsor in german
* .gitattributes -> the necessary gitattributes file
* .gitignore -> the necessary gitignore file
* README.md -> this readme file
* inputs.md -> description of necessary inputs for parsor
* parsor.exe -> the exe file for windows user
* parsor.rb -> the ruby development file
* runparsor.m -> the automatic matlab calling file (windows)
* runrapidminer.m -> the automatic rapidminer calling file (windows)

## tested and working on
* ruby 2.1.1p76 (2014-02-24 revision 45161) [x86_64-darwin13.0]
* ruby 2.0.0-p451 (x64) [win]
* should run if ruby >= 2.0.0
* distributed exe-files for Windows

by Christopher Sauer, 2014
