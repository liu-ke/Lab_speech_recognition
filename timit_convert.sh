#!/bin/bash

# Abfrage des Speicherorts der Timit Datenbank
function getTimitPath
{
  timitPathDone=false

  while [ $timitPathDone = false ]; do
    echo 'Enter the path of the timit database:'
    read timitPath
    if [ -d "$timitPath" ]; then
      timitPathDone=true
      # Pfadangabe endet mit 'timit' -> '/' anhängen
      myregex='.*timit$'
      if [[ $timitPath =~ $myregex ]]; then
        timitPath="$timitPath/"
      fi
      echo -e "Path where the script will look for the timit wave files:\n\t$timitPath"
    else
      echo 'ERROR: Invalid path!'
    fi
  done
}

# Abfrage des Speicherorts um die konvertierten Daten abzulegen
function getOutputPath
{
  outputPath="${timitPath%/*/}/timit_wave/"
  echo -e "The converted wave file will be stored in:\n\t$outputPath"

}

# Abfrage wo Konvertierungsprogramm 'sph2pipe' liegt
function getSPH2PIPE
{
  sphDone=false

  while [ $sphDone = false ]; do
    echo 'Enter path to sph2pipe (.../sph2pipe)'
    read sphPath
    if [ ! -f $sphPath ]; then
      echo "ERROR: Cannot execute $sphPath"
    else
      sphDone=true
    fi
  done
}

# Suchen aller wave Dateien unter 'timitPath' und konvertieren in standart wave Dateien
function convertWaveFiles
{
  for f in $(find $timitPath -name '*.wav'); do

    # voller Dateiname der konvertieren Datei
    targetFile=$outputPath${f#$timitPath}
    echo "$f -> $targetFile"

    # Prüfen ob Verzeichnis vorhanden, sonst erzeugen
    if [ ! -d ${targetFile%/*} ];then
	mkdir -p ${targetFile%/*}
    fi

    # konvertieren mit sph2pip
    $sphPath -f rif $f $targetFile
  done
}

# HAUPTPROGRAMM
echo -e "#########################################################################"
echo -e "Skript to convert Timit audio files into standard wave files.\nAuthor: Marcel Weber\nVersion: 1.0 (19.09.2014)" 
echo -e "#########################################################################"

getTimitPath
getOutputPath
getSPH2PIPE
convertWaveFiles

echo -e "FINISHED. All files converted to standard wave files."
