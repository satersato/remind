Changing inputs in REMIND model
================
Miško Stevanović (<stevanovic@pik-potsdam.de>), Lavinia Baumstark (<baumstark@pik-potsdam.de>)

-   [Introduction](#introduction)
-   [Local Input Data](#local-input-data)
-   [Adding New Input Data](#adding-new-input-data)
-   [How to Update Input Data](#how-to-update-input-data)

Introduction
===============

The input data for REMIND is prepared by a set of pre-processing routines that take the data from original sources (e.g. IEA, GTAP, PWT...), execute additional calculations and convert it to the required REMIND parameter format. 

The input files are setup in the config file `config/default.cfg`. The regional resolution of the run is set in the by 
``` bash
cfg$regionmapping
```
(default setting: regionmapping <- "config/regionmappingH12.csv"). Based on the regional resolution and the input data revision 
``` bash
cfg$inputRevision
```
the name of the needed input data is constructed. It is checked whether those input data are already available. If not they are automatically downloaded from `/p/projects/rd3mod/inputdata/output/` and distributed.

The prepared input data is a compressed tar archive file "`.tgz`", which can be opened with software such as [7-Zip](https://www.7-zip.org/), or in terminal by `tar` and `untar` commands. 

Local Input Data
==================
If you like to get the input data on your local machine you need to copy your ssh key (`/home/[your_cluster_user_name]/.ssh/id_dsa`) to your computer and adjust your local **.Rprofile** by adding the following line:
``` r
options(remind_repos=list("scp://cluster.pik-potsdam.de/p/projects/rd3mod/inputdata/output"=list(username="[your_cluster_user_name]",ssh_private_keyfile="[path_to_your_local_copy_of_your_key]")))
```
If your key is password-protected you have to remove this by using an empty passphrase:  
``` cmd 
ssh-keygen -p
-> path to id_dsa
-> empty passphrase
```
It is recommended to first copy the existing key (e.g. id_dsa into id_dsa-local) and remove the passphrase of this copy and copy it to your machine.

If you plan to run REMIND not with the default regional resolution you have to take care that REMIND starts from a gdx with the correct regional resolution. Either you can use one from an older run with the corresponding regional resolution or you can construct a new gdx with the correct regional resolution from a gdx in a different regional resolution by using the function `gdx_rename` from the package (gdx) (e.g. `gdx_rename("input.gdx",set_name="all_regi",c(REF="RUS",CAZ="ROW",...,MEA="MEA",USA="USA"))`).


Adding New Input Data
======================

The input data for REMIND are generated by using the R-libraries *mrremind* (https://github.com/pik-piam/mrremind) and *madrat* (https://github.com/pik-piam/madrat). While *mrremind* contains all calculations tailored to REMIND-input-data, the package *madrat* provides the general wrapper functions and helpful tools. For further information read the vignettes of these R-packages.

How to Update Input Data
========================

1. Check for the current input data revision number in this cluster folder: `/p/projects/rd3mod/inputdata/cache`. Alternatively, run the helper tool `lastRev` (`/p/projects/rd3mod/tools/lastrev`) to get a list of the last five revX.XXX*_remind.tgz items in the default moinput output directory.
2. Clone the repo [`https://gitlab.pik-potsdam.de/REMIND/preprocessing-remind`](https://gitlab.pik-potsdam.de/REMIND/preprocessing-remind) to your tmp folder on the cluster and edit its `start.R` file by inserting the next revision number. Use at least 4 decimal places for development/testing. If an old revision number is used, the input data will not be recalculated. Input data for a new regional resolution will be recalculated based on the existing cache information.

3. Start the script with

``` bash
sbatch slurm_start.sh
```

The .log file lists the progress and potential errors. This process might take a while (currently >8 hours).

4. If the process terminates without errors, do a test run with the new input data. To do this, clone the REMIND repo and update the data input version `cfg$revision` in `config/default.cfg` using your recently created data revision number file and run one scenario (e.g. SSP2EU-Base).
5. If the test run completes without errors, add the change in `config/default.cfg` and the update of the Input data revision in `main.gms` that was automatically performed by the REMIND run to a commit in your REMIND clone. This can be best done by using
``` bash
git add -p config/default.cfg main.gms
````
and then selecting the change in `default.cfg` and the first change to the input data in `main.gms` with `y`, and then ignoring possible other changes in `main.gms` with `d`. Create a pull request to push this change to the main REMIND repository, and REMIND will use the new data by default.
