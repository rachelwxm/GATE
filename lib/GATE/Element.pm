=pod 

=head1 NAME

GATE::Element - Generate the element bits for GATE.pm

=head1 AUTHOR

BENM(Binxiao) Feng, binxiaofeng@gmail.com

=head1 SEE ALSO
##########################################################################
#  Copyright (c) 2012 - 2013 - BENM(Binxiao) Feng                        #
#  All Rights Reserved                                                   #
#  Send all comments to BENM - BinxiaoFeng\@gmail.com                     #
#                                                                        #
#  This program is free software: you can redistribute it and/or modify  #
#  it under the terms of the GNU General Public License as published by  #
#  the Free Software Foundation, either version 3 of the License, or     #
#  (at your option) any later version.                                   #
#  This program is distributed in the hope that it will be useful,       #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of        #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
#  GNU General Public License for more details.                          #
#  You should have received a copy of the GNU General Public License     #
#  along with this program.  If not, see <http://www.gnu.org/licenses/>. #
##########################################################################

=cut

package GATE::Element;
use FindBin qw($Bin $Script);
use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/../../lib";
use File::Basename qw(basename dirname);
use GATE::DO;

$VERSION = "0.2a";

use strict;
#use GATE::Extension;
use vars qw($AUTOLOAD %autosubs);

my @autosubs=qw(
	config workdir
	qa aln exp diff as
);

%autosubs=map { $_ => 1 } @autosubs;

sub new ($$;@) {
	my ($proto,$name,%attrs)=@_;
	my $class=ref($proto) || $proto;
	my $self={-name => $name};
	foreach my $key (keys %attrs) {
		$self->{$key}=$attrs{$key};
	}
	return bless($self,$class);
}

sub qc($) {
	my $self=shift;
	$self->selectIdxFastq().$self->mergeOverlapPE().$self->runQA().$self->runFltDup().$self->runFltAP().$self->runRSeQC().$self->runRNASeqQC();
}

sub aln($) {
	my $self=shift;
	$self->runBWA().$self->runTopHat();
}

sub var($) {
	my $self=shift;
	$self->callVar();
}

sub exp($) {
	my $self=shift;
	$self->runCufflinks('-ref',"yes").$self->runCuffCompare().$self->runCuffMerge;
}

sub diff($) {
	my $self=shift;
	$self->runCuffdiff('ref','merged-gtf');
}

sub as($) {
	my $self=shift;
	$self->runAlternativeSplicing().$self->runASAP();
}

sub plot($) {
	my $self=shift;
	$self->GenePlot();
}

sub denovo($) {
	my $self=shift;
	$self->runTrinity();
}

sub predict($) {
	my $self=shift;
}

sub phylgen($) {
	my $self=shift;
	$self->runClustalW2().$self->runMrBayes();
}


1;