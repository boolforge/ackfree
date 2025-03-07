procedure exportmap(thisregion:byte);

begin {alt-V}

          assign(chf,ADVNAME+MAPAFILE+strnum(thisregion));
           reset(chf);  // Removed {$I-} and {$I+} directives
          if ioresult=0 then
          begin
           for xchunkloc:=1 to 20 do
            for ychunkloc:=1 to 12 do

              if region.room.wmap[xchunkloc,ychunkloc]<>0 then
             begin
              {$I-}
              seek(chf,region.room.wmap[xchunkloc,ychunkloc]-1);
              read(chf,map[2,2]);
              {$I+}
              for pointx:=0 to 15 do for pointy:=0 to 15 do
               putpixel(pointx+(xchunkloc-topx)*16,
                        pointy+(ychunkloc-topy)*16,
                        map[2,2,pointx+1,pointy+1].o);
             end;

          end;
          pointmode:=0;
          say(2,191,0,'ESC:EXIT   ARROW KEYS:MOVE');
          repeat
           case upcase_sync(readkey) of
            #27:begin;done2:=true;pointmode:=1;end;
            #0:case readkey of
                'H':begin;if topy>1 then dec(topy);pointmode:=1;end;
                'K':begin;if topx>1 then dec(topx);pointmode:=1;end;
                'P':begin;if topy<20 then inc(topy);pointmode:=1;end;
                'M':begin;if topx<12 then inc(topx);pointmode:=1;end;
                'G':begin;topx:=1;topy:=1;pointmode:=1;end;
               end;
           end;
repeat  // Added REPEAT to match the first UNTIL
          until pointmode=1;
         repeat  // Added REPEAT to match the second UNTIL
         until done2;
          close(chf);  // Removed {$I-} and {$I+} directives
         clearscreen;
        if region.rooms=254 then
         begin
          cwmap_scrollbars;
          previewcells(topx,topy);
         end;
          // Removed extra END on line 59 (previously identified)
    end;
