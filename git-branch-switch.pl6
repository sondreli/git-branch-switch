#!/usr/bin/perl6

my $configDir = "%*ENV<HOME>/.config/git-branch-switch/";
my $branchesFile = "{$configDir}last-used-branches";
if not ($branchesFile).IO.e {
    mkdir $configDir;
    spurt $configDir ~ $branchesFile, "";
}
my @lastBranches = $branchesFile.IO.lines;

my @branches = q:x/git branch/.comb(/<[\w \- .]>+/);

my @sortedBranches = updateBranches(@lastBranches, @branches);

for @sortedBranches.kv -> $index, $branch {
    say "[$index.fmt('%2d')] $branch";
}

my $pick = prompt("");
my $pickedBranch = @sortedBranches[$pick];

unless 0 <= $pick < @branches { die "Index out of range!" };

shell "git checkout $pickedBranch";

@sortedBranches .= grep: * ne $pickedBranch;
@sortedBranches.push($pickedBranch);

my $fh = open $branchesFile, :w;
$fh.print(@sortedBranches.join("\n"));
$fh.close;


sub updateBranches(@lastBranches, @branches) {
    my @intersection = @lastBranches.grep({ @branches.contains($_) });
    my @newBranches = @branches.grep({ !@intersection.contains($_) });
    flat @intersection, @newBranches;
}
