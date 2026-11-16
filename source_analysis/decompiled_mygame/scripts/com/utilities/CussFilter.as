package com.utilities
{
   public class CussFilter
   {
      
      private static const badWords_string:String = new String("ahole,anus,ash0le,ash0les,asholes,Assface,assh0le,assh0lez,asshole,assholes,assholz,asswipe,azzhole,bassterds,bastard,bastards,bastardz,basterds,basterdz,Biatch,bitch,bitches,Blow Job,boffing,butthole,buttwipe,c0ck,c0cks,c0k,Carpet Muncher,cawk,cawks,Clit,cnts,cntz,cock,cockhead,cock-head,cocks,CockSucker,cock-sucker,cunt,cunts,cuntz,dick,dild0,dild0s,dildo,dildos,dilld0,dilld0s,dominatricks,dominatrics,dominatrix,dyke,enema,f u c k,f u c k e r,fag,fag1t,faget,fagg1t,faggit,faggot,fagit,fags,fagz,fuck,fucker,fuckin,fucking,fucks,Fudge Packer,fuk,Fukah,Fuken,fuker,Fukin,Fukk,Fukkah,Fukken,Fukker,Fukkin,g00k,gayboy,gaygirl,God-damned,jackoff,jap,japs,jerk-off,jisim,jiss,jizm,jizz,kunt,kunts,kuntz,Lesbian,Lezzian,Lipshits,Lipshitz,masochist,masokist,massterbait,masstrbait,masstrbate,masterbaiter,masterbate,masterbates,Motha Fucker,Motha Fuker,Motha Fukkah,Motha Fukker,Mother Fucker,Mother Fukah,Mother Fuker,Mother Fukkah,Mother Fukker,mother-fucker,Mutha Fucker,Mutha Fukah,Mutha Fuker,Mutha Fukkah,Mutha Fukker,n1gr,nigger,nigur,niiger,niigr,orafis,orgasim,orgasm,orgasum,oriface,orifice,orifiss,packi,packie,packy,paki,pakie,paky,pecker,peeenus,peeenusss,peenus,peinus,pen1s,penas,penis,penis-breath,penus,penuus,Phuc,Phuck,Phuk,Phuker,Phukker,polac,polack,polak,Poonani,pr1c,pr1ck,pr1k,pusse,pussee,pussy,puuke,puuker,queer,queers,queerz,qweers,qweerz,qweir,recktum,rectum,retard,sadist,scank,schlong,screwing,sex,sexy,Sh!t,sh1t,sh1ter,sh1ts,sh1tter,sh1tz,shit,shits,shitter,Shitty,Shity,shitz,Shyt,Shyte,Shytty,Shyty,skanck,skank,skankee,skankey,skanks,Skanky,slut,sluts,Slutty,slutz,son-of-a-bitch,va1jina,vag1na,vagiina,vagina,vaj1na,vajina,vullva,vulva,w0p,wh00r,wh0re,whore,xrated");
      
      private static const badWords_array:Array = badWords_string.split(",");
      
      private static var leftOver_string:String = new String();
      
      private static var original_string:String = new String();
      
      private static var len:int = new int(0);
      
      private static var whileCounter:int = new int(0);
      
      private static const charReplacements:Array = [["@","a"],["0","o"],["1","i"],["2","r"],["3","e"],["4","a"],["5","s"],["7","t"],["8","b"],["9","g"],["|<","k"],["|/|","m"],["||","n"],["ä","a"],["ã","a"],["â","a"],["ä","a"],["á","a"],["à","a"],["å","a"],["é","e"],["è","e"],["ë","e"],["ê","e"],["§","s"],["$","s"],["£","l"],["€","e"],["ü","u"],["û","u"],["ú","u"],["ù","u"],["î","i"],["ï","i"],["í","i"],["ì","i"],["ÿ","y"],["ý","y"],["ö","o"],["ô","o"],["õ","o"],["ó","o"],["ò","o"],["(.)","boob"]];
      
      public function CussFilter()
      {
         super();
      }
      
      public static function checkString(param1:String) : String
      {
         var _loc2_:Object = null;
         var _loc3_:Array = null;
         param1 = param1.toLowerCase();
         var _loc4_:int = 0;
         while(_loc4_ < charReplacements.length)
         {
            _loc3_ = charReplacements[_loc4_] as Array;
            param1 = strReplace(param1,_loc3_[0],_loc3_[1]);
            _loc4_++;
         }
         for each(_loc2_ in badWords_array)
         {
            if(param1.indexOf(String(_loc2_)) != -1)
            {
               return String(_loc2_);
            }
         }
         return "";
      }
      
      public static function checkAndSubstitute(param1:String) : String
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         original_string = param1;
         param1 = param1.toLowerCase();
         var _loc4_:int = 0;
         while(_loc4_ < charReplacements.length)
         {
            _loc2_ = charReplacements[_loc4_] as Array;
            param1 = strReplace(param1,_loc2_[0],_loc2_[1]);
            _loc4_++;
         }
         var _loc5_:* = 0;
         while(_loc5_ < badWords_array.length)
         {
            if(param1.indexOf(badWords_array[_loc5_]) != -1)
            {
               leftOver_string = param1.substr(param1.indexOf(badWords_array[_loc5_]) + badWords_array[_loc5_].length,param1.length);
               param1 = param1.substr(0,param1.indexOf(badWords_array[_loc5_])) + badWords_array[_loc5_].charAt(0);
               _loc3_ = 0;
               while(_loc3_ < badWords_array[_loc5_].length - 1)
               {
                  param1 += "*";
                  _loc3_++;
               }
               param1 += leftOver_string;
               _loc5_--;
            }
            _loc5_++;
         }
         len = original_string.length;
         _loc4_ = 0;
         while(_loc4_ < len)
         {
            if(original_string.charAt(_loc4_) != param1.charAt(_loc4_) && param1.charAt(_loc4_) != "*")
            {
               param1 = param1.substr(0,_loc4_) + original_string.charAt(_loc4_) + param1.substr(_loc4_ + 1,param1.length);
            }
            _loc4_++;
         }
         return param1;
      }
      
      public static function strReplace(param1:String, param2:String, param3:String) : String
      {
         whileCounter = 0;
         while(param1.indexOf("find") != -1 && whileCounter < 100)
         {
            ++whileCounter;
         }
         param1 = param1.split(param2).join(param3);
         return param1.split(param2).join(param3);
      }
   }
}

