*** |  (C) 2006-2022 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/31_fossil/MOFEX/sets.gms
sets
enty2rlf_dec(all_enty,rlf)        "mapping for applying constraint on decline rate of vm_fuExtr"
/
        peoil.(1*8)
        pegas.(1*6)
        pecoal.(1*6)
/
enty2rlf_inc(all_enty,rlf)        "mapping for applying constraint on growth rate of vm_fuExtr (see module 31_fossil)"
/
        peoil.(1*8)
        pegas.(1*6)
        pecoal.(1*6)
/
;
*** EOF ./modules/31_fossil/MOFEX/sets.gms
