#!/usr/bin/perl

use strict;
use warnings;
use File::Basename;
use File::Copy;
use POSIX qw(strftime); 

my $timestamp = localtime();
my $timestampBackup = strftime "%Y_%m_%d", localtime();
my @directoryPath = qw(
        C:/Users/PCLE02911/Documents/Elastic/kibana-5.0.0-windows-x86
        C:/Users/PCLE02911/Documents/Elastic/kibana-5.0.0-windows-x86-1
        );
my @exts = qw(.tmp.zip .zip);

foreach my $directoryPath (@directoryPath){
        my @files = getFilesList ("$directoryPath/plugins");
        foreach my $file (@files) {
                if (-e $file) {
                        my($filename, $directory, $ext) = fileparse("$file", @exts);
                        if($ext eq '.tmp.zip'){
                                rename $file, "$directoryPath/plugins/${filename}.zip";
                                open my $fh, '>>',"$directoryPath/logs/${filename}.log" or die "Can't create the log file [$filename] because this: $!\n";
                                print $fh "$timestamp: Removing the plugin before install\n";
                                system "C:/Users/PCLE02911/Documents/Elastic/kibana-5.0.0-windows-x86/bin/kibana-plugin.bat remove $filename >> $directoryPath/logs/${filename}.log 2>&1";
                                print $fh "$timestamp: Installation of the plugin Kibana $filename \n";
                                system "C:/Users/PCLE02911/Documents/Elastic/kibana-5.0.0-windows-x86/bin/kibana-plugin.bat install file://$directoryPath/plugins/${filename}.zip >> $directoryPath/logs/${filename}.log 2>&1";
                                close $fh;
                                rename "$directoryPath/plugins/${filename}.zip", "$directoryPath/plugins_backup/${filename}_$timestampBackup.zip";
                        } else {
                                print "unknown extension \n";
                        }
                }
        }
}

print "En attente de nouveau fichier d'installation...\n";

## F U N C T I O N

# GetFilesList - Renvoie la liste des fichiers d'un repertoire (en mode recursif)

sub getFilesList
{
        my $Path = $_[0];
        my $FileFound;
        my @FilesList=();

        # Lecture de la liste des fichiers
        opendir (my $FhRep, $Path) or die "Impossible d'ouvrir le repertoire $Path\n";
        my @Contenu = grep { !/^\.\.?$/ } readdir($FhRep);

        closedir ($FhRep);

        foreach my $FileFound (@Contenu) {
                # Traitement des fichiers
                if ( -f "$Path/$FileFound") {
                        push ( @FilesList, "$Path/$FileFound" );
                }
                # Traitement des repertoires
                #elsif ( -d "$Path/$FileFound") {
                        # Boucle pour lancer la recherche en mode recursif
                        #push (@FilesList, getFilesList("$Path/$FileFound") );
                #}
        }
	return @FilesList;
}