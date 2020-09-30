\d .sctp

chainedtp:@[value;`chainedtp;0b];  /- sets process up as a chained segmented tickerplant

tickerplantname:@[value;`tickerplantname;`stp1];                /- tickerplant name to try and make a connection to  
createlogs:@[value;`createlogs;1b];                             /- allow chained tickerplant to create a log file
subscribeto:@[value;`subscribeto;`];                            /- list of tables to subscribe for
subscribesyms:@[value;`subscribesyms;`];                        /- list of syms to subscription to
replay:@[value;`replay;0b];                                     /- replay the tickerplant log file
schema:@[value;`schema;1b];                                     /- retrieve schema from tickerplant

/- subscribe to segmented tickerplant
subscribe:{[]
  s:.sub.getsubscriptionhandles[`;tickerplantname;()!()];
  if[count s;
      subproc:first s;
      tph:subproc`w;
      /- get tickerplant date - default to today's date
      .lg.o[`subscribe;"subscribing to ", string subproc`procname];
      r:.sub.subscribe[subscribeto;subscribesyms;schema;replay;subproc];
      if[`d in key r;.u.d::r[`d]];
      if[(`icounts in key r) & (not createlogs); /- dict r contains icounts & not using own logfile
        subtabs:$[subscribeto~`;key r`icounts;subscribeto],();
        .u.jcounts::.u.icounts::$[0=count r`icounts;()!();subtabs!enlist [r`icounts]subtabs];
      ]
    ];
  }

\d .

upd:{[t;x]
  if[not .sctp.chainedtp; :()];
  // extract data from incoming table as a list
  x:flip value each x;
  .u.upd[t;x]
 }
