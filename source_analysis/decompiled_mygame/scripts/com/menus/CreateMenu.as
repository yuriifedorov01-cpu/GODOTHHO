package com.menus
{
   import com.apis.*;
   import com.game_objects.*;
   import com.greensock.*;
   import com.greensock.easing.*;
   import com.ui.*;
   import com.utilities.*;
   import feathers.controls.*;
   import playerio.PlayerIOError;
   import starling.*;
   import starling.core.*;
   import starling.display.*;
   import starling.events.*;
   import starling.filters.*;
   import starling.text.*;
   import starling.textures.Texture;
   import starling.textures.TextureAtlas;
   import starling.utils.*;
   
   public final class CreateMenu extends Sprite
   {
      
      public static var charCreateMenu_textureAtlas:TextureAtlas;
      
      public var beardLeft_btn:Button;
      
      public var beardRight_btn:Button;
      
      private var terms_btn:Button;
      
      public var skinLeft_btn:Button;
      
      public var skinRight_btn:Button;
      
      public var eyesLeft_btn:Button;
      
      public var eyesRight_btn:Button;
      
      public var hairLeft_btn:Button;
      
      public var hairRight_btn:Button;
      
      public var genderLeft_btn:Button;
      
      public var genderRight_btn:Button;
      
      public var classLeft_btn:Button;
      
      public var classRight_btn:Button;
      
      public var nameBorder:Image;
      
      public var passBorder:Image;
      
      public var emailBorder:Image;
      
      public var finished_btn:Button;
      
      public var back_btn:Button;
      
      public var gender_txt:TextField;
      
      public var hair_txt:TextField;
      
      public var eyes_txt:TextField;
      
      public var skin_txt:TextField;
      
      public var beard_txt:TextField;
      
      public var class_txt:TextField;
      
      public var classDesc_txt:TextField;
      
      public var classTitle_txt:TextField;
      
      public var emailColon_txt:TextField;
      
      public var emailNotice_txt:TextField;
      
      public var passwordColon_txt:TextField;
      
      public var email_txt:TextInput;
      
      public var name_txt:TextInput;
      
      public var password_txt:TextInput;
      
      public var personClone:Person;
      
      private var leftPersonClone:Person;
      
      private var rightPersonClone:Person;
      
      private var classItem:Item;
      
      private var tree1_image:Image;
      
      private var tree2_image:Image;
      
      private var tree3_image:Image;
      
      private var tree4_image:Image;
      
      private var tree5_image:Image;
      
      private var tree6_image:Image;
      
      public var woodPlatform_image:Image;
      
      public function CreateMenu(param1:GameMain)
      {
         var errorLine:int = 0;
         var nonChange_texture:Texture = null;
         var nonChange_image:Image = null;
         var colorFilter:ColorMatrixFilter = null;
         var _gameMain:GameMain = param1;
         super();
         errorLine = 0;
         try
         {
            this.beardLeft_btn = new Button(charCreateMenu_textureAtlas.getTexture("left_00"),"",null,charCreateMenu_textureAtlas.getTexture("left_01"));
            errorLine = 50;
            this.beardRight_btn = new Button(charCreateMenu_textureAtlas.getTexture("right_00"),"",null,charCreateMenu_textureAtlas.getTexture("right_01"));
            this.terms_btn = new Button(charCreateMenu_textureAtlas.getTexture("terms_00"));
            this.skinLeft_btn = new Button(this.beardLeft_btn.upState,"",null,this.beardLeft_btn.overState);
            this.skinRight_btn = new Button(this.beardRight_btn.upState,"",null,this.beardRight_btn.overState);
            this.eyesLeft_btn = new Button(this.beardLeft_btn.upState,"",null,this.beardLeft_btn.overState);
            this.eyesRight_btn = new Button(this.beardRight_btn.upState,"",null,this.beardRight_btn.overState);
            this.hairLeft_btn = new Button(this.beardLeft_btn.upState,"",null,this.beardLeft_btn.overState);
            this.hairRight_btn = new Button(this.beardRight_btn.upState,"",null,this.beardRight_btn.overState);
            this.genderLeft_btn = new Button(this.beardLeft_btn.upState,"",null,this.beardLeft_btn.overState);
            this.genderRight_btn = new Button(this.beardRight_btn.upState,"",null,this.beardRight_btn.overState);
            this.classLeft_btn = new Button(this.beardLeft_btn.upState,"",null,this.beardLeft_btn.overState);
            this.classRight_btn = new Button(this.beardRight_btn.upState,"",null,this.beardRight_btn.overState);
            errorLine = 1;
            this.nameBorder = new Image(charCreateMenu_textureAtlas.getTexture("input box"));
            this.passBorder = new Image(this.nameBorder.texture);
            this.emailBorder = new Image(this.nameBorder.texture);
            errorLine = 2;
            this.finished_btn = new Button(charCreateMenu_textureAtlas.getTexture("finished_00"));
            this.back_btn = new Button(charCreateMenu_textureAtlas.getTexture("back_00"));
            this.gender_txt = new TextField(211,32,"boy",AllTextFormats.type_textFormat);
            this.hair_txt = new TextField(211,32,"spiked brown",AllTextFormats.type_textFormat);
            this.eyes_txt = new TextField(211,32,"round",AllTextFormats.type_textFormat);
            this.skin_txt = new TextField(211,32,"peach",AllTextFormats.type_textFormat);
            this.beard_txt = new TextField(211,32,"none",AllTextFormats.type_textFormat);
            this.class_txt = new TextField(211,32,"warrior",AllTextFormats.type_textFormat);
            errorLine = 3;
            this.classDesc_txt = new TextField(378,147,"",AllTextFormats.classDesc_textFormat);
            this.classTitle_txt = new TextField(181,34,"The Warrior",AllTextFormats.title_textFormat);
            this.emailColon_txt = new TextField(80,32,"*email:",AllTextFormats.colon_textFormat);
            this.emailNotice_txt = new TextField(554,20,"(note: if you don\'t enter an email address you will not be able to recover a forgotten password)",AllTextFormats.emailNotice_textFormat);
            this.passwordColon_txt = new TextField(114,32,"password:",AllTextFormats.colon_textFormat);
            errorLine = 4;
            this.email_txt = new TextInput();
            this.name_txt = new TextInput();
            this.password_txt = new TextInput();
            errorLine = 5;
            this.tree1_image = new Image(Assets.treesFish_textureAtlas.getTexture("palm tree"));
            this.tree2_image = new Image(this.tree1_image.texture);
            this.tree3_image = new Image(this.tree1_image.texture);
            this.tree4_image = new Image(this.tree1_image.texture);
            this.tree5_image = new Image(this.tree1_image.texture);
            this.tree6_image = new Image(this.tree1_image.texture);
            this.woodPlatform_image = new Image(charCreateMenu_textureAtlas.getTexture("wooden platform"));
            errorLine = 6;
         }
         catch(_error:Error)
         {
            MainStarlingStage(Starling.current.root).gameMain.createAlert(String(charCreateMenu_textureAtlas == null));
         }
         nonChange_texture = charCreateMenu_textureAtlas.getTexture(Steam.onSteam == false ? "nonChange" : "nonChange no terms");
         nonChange_image = new Image(nonChange_texture);
         nonChange_image.x = -387;
         nonChange_image.y = -320;
         nonChange_image.touchable = false;
         addChild(nonChange_image);
         this.back_btn.x = -400;
         this.back_btn.y = -321;
         this.back_btn.pivotX = 63;
         this.back_btn.pivotY = 18;
         this.back_btn.scaleWhenOver = 0.95;
         this.back_btn.name = "createBack_btn";
         addChild(this.back_btn);
         this.finished_btn.x = 228;
         this.finished_btn.y = 251;
         this.finished_btn.pivotX = 41;
         this.finished_btn.pivotY = 22;
         this.finished_btn.scaleWhenOver = 0.95;
         this.finished_btn.name = "finished_btn";
         addChild(this.finished_btn);
         if(Steam.onSteam == false)
         {
            this.terms_btn.x = 247;
            this.terms_btn.y = 295;
            this.terms_btn.pivotX = 58;
            this.terms_btn.pivotY = 11;
            this.terms_btn.scaleWhenOver = 0.95;
            this.terms_btn.name = "terms_btn";
            addChild(this.terms_btn);
         }
         this.nameBorder.y = -170;
         addChild(this.nameBorder);
         this.passBorder.y = -125;
         addChild(this.passBorder);
         if(GameMain.isMobile == false)
         {
            this.emailBorder.y = -80;
            addChild(this.emailBorder);
            this.emailBorder.x = 138;
         }
         this.passBorder.x = this.nameBorder.x = 138;
         this.passBorder.touchable = this.emailBorder.touchable = this.nameBorder.touchable = false;
         this.beardLeft_btn.name = "beardLeft_btn";
         addChild(this.beardLeft_btn);
         this.beardRight_btn.y = this.beardLeft_btn.y = 180;
         this.beardRight_btn.name = "beardRight_btn";
         addChild(this.beardRight_btn);
         this.skinLeft_btn.name = "skinLeft_btn";
         addChild(this.skinLeft_btn);
         this.skinRight_btn.y = this.skinLeft_btn.y = 139;
         this.skinRight_btn.name = "skinRight_btn";
         addChild(this.skinRight_btn);
         this.eyesLeft_btn.name = "eyesLeft_btn";
         addChild(this.eyesLeft_btn);
         this.eyesRight_btn.y = this.eyesLeft_btn.y = 98;
         this.eyesRight_btn.name = "eyesRight_btn";
         addChild(this.eyesRight_btn);
         this.hairLeft_btn.name = "hairLeft_btn";
         addChild(this.hairLeft_btn);
         this.hairRight_btn.y = this.hairLeft_btn.y = 59;
         this.hairRight_btn.name = "hairRight_btn";
         addChild(this.hairRight_btn);
         this.genderLeft_btn.name = "genderLeft_btn";
         addChild(this.genderLeft_btn);
         this.genderRight_btn.y = this.genderLeft_btn.y = 19;
         this.genderRight_btn.name = "genderRight_btn";
         addChild(this.genderRight_btn);
         this.classLeft_btn.x = this.genderLeft_btn.x = this.hairLeft_btn.x = this.eyesLeft_btn.x = this.skinLeft_btn.x = this.beardLeft_btn.x = 145;
         this.classLeft_btn.name = "classLeft_btn";
         addChild(this.classLeft_btn);
         this.classRight_btn.x = this.genderRight_btn.x = this.hairRight_btn.x = this.eyesRight_btn.x = this.skinRight_btn.x = this.beardRight_btn.x = 384;
         this.classRight_btn.y = this.classLeft_btn.y = -202;
         this.classRight_btn.pivotX = this.classLeft_btn.pivotX = this.genderRight_btn.pivotX = this.genderLeft_btn.pivotX = this.hairRight_btn.pivotX = this.hairLeft_btn.pivotX = this.eyesRight_btn.pivotX = this.eyesLeft_btn.pivotX = this.skinRight_btn.pivotX = this.skinLeft_btn.pivotX = this.beardRight_btn.pivotX = this.beardLeft_btn.pivotX = 8;
         this.classRight_btn.pivotY = this.classLeft_btn.pivotY = this.genderRight_btn.pivotY = this.genderLeft_btn.pivotY = this.hairRight_btn.pivotY = this.hairLeft_btn.pivotY = this.eyesRight_btn.pivotY = this.eyesLeft_btn.pivotY = this.skinRight_btn.pivotY = this.skinLeft_btn.pivotY = this.beardRight_btn.pivotY = this.beardLeft_btn.pivotY = 14;
         this.classRight_btn.name = "classRight_btn";
         addChild(this.classRight_btn);
         if(GameMain.isMobile == false)
         {
            this.emailNotice_txt.x = -133;
            this.emailNotice_txt.y = -240;
            addChild(this.emailNotice_txt);
            this.emailColon_txt.x = 46;
            this.emailColon_txt.y = -78;
            addChild(this.emailColon_txt);
         }
         this.classTitle_txt.x = -280;
         this.classTitle_txt.y = 13;
         addChild(this.classTitle_txt);
         this.passwordColon_txt.x = 12;
         this.passwordColon_txt.y = -124;
         addChild(this.passwordColon_txt);
         this.passwordColon_txt.batchable = this.emailColon_txt.batchable = this.classTitle_txt.batchable = this.emailNotice_txt.batchable = true;
         this.classDesc_txt.x = -382;
         this.classDesc_txt.y = 55;
         this.classDesc_txt.touchable = false;
         this.classDesc_txt.batchable = true;
         addChild(this.classDesc_txt);
         this.class_txt.y = -214;
         addChild(this.class_txt);
         this.gender_txt.y = 7;
         addChild(this.gender_txt);
         this.hair_txt.y = 47;
         addChild(this.hair_txt);
         this.eyes_txt.y = 87;
         addChild(this.eyes_txt);
         this.skin_txt.y = 127;
         addChild(this.skin_txt);
         this.beard_txt.x = this.skin_txt.x = this.eyes_txt.x = this.hair_txt.x = this.gender_txt.x = this.class_txt.x = 161;
         this.beard_txt.y = 167;
         addChild(this.beard_txt);
         this.beard_txt.batchable = this.skin_txt.batchable = this.eyes_txt.batchable = this.hair_txt.batchable = this.gender_txt.batchable = this.class_txt.batchable = true;
         this.beard_txt.touchable = this.skin_txt.touchable = this.eyes_txt.touchable = this.hair_txt.touchable = this.gender_txt.touchable = this.emailNotice_txt.touchable = this.classTitle_txt.touchable = this.emailColon_txt.touchable = this.class_txt.touchable = false;
         this.email_txt.y = -76;
         this.email_txt.name = this.email_txt.textEditorProperties.name = "email_txt";
         this.email_txt.maxChars = 40;
         addChild(this.email_txt);
         this.name_txt.y = -166;
         this.name_txt.name = this.name_txt.textEditorProperties.name = "name_txt";
         this.name_txt.maxChars = 25;
         addChild(this.name_txt);
         this.password_txt.y = -121;
         this.password_txt.width = this.name_txt.width = this.email_txt.width = 250;
         this.password_txt.displayAsPassword = true;
         this.password_txt.maxChars = 25;
         addChild(this.password_txt);
         this.password_txt.x = this.name_txt.x = this.email_txt.x = 142;
         this.password_txt.height = this.name_txt.height = this.email_txt.height = 35;
         this.password_txt.textEditorProperties.fontFamily = this.name_txt.textEditorProperties.fontFamily = this.email_txt.textEditorProperties.fontFamily = "arial";
         this.password_txt.textEditorProperties.fontSize = this.name_txt.textEditorProperties.fontSize = this.email_txt.textEditorProperties.fontSize = 28;
         this.tree1_image.x = -389;
         this.tree1_image.y = 170;
         addChildAt(this.tree1_image,0);
         this.tree2_image.x = 259;
         this.tree2_image.y = 177;
         addChildAt(this.tree2_image,0);
         this.woodPlatform_image.x = -192;
         this.woodPlatform_image.y = 62;
         this.woodPlatform_image.pivotX = 38;
         this.woodPlatform_image.pivotY = 125;
         this.woodPlatform_image.touchable = false;
         addChildAt(this.woodPlatform_image,0);
         this.tree3_image.x = -435;
         this.tree3_image.y = 63;
         addChildAt(this.tree3_image,0);
         this.tree4_image.x = 179;
         this.tree4_image.y = 79;
         addChildAt(this.tree4_image,0);
         this.tree5_image.x = -479;
         this.tree5_image.y = 27;
         addChildAt(this.tree5_image,0);
         this.tree6_image.x = 232;
         this.tree6_image.y = 27;
         this.tree6_image.touchable = this.tree5_image.touchable = this.tree4_image.touchable = this.tree3_image.touchable = this.tree1_image.touchable = false;
         addChildAt(this.tree6_image,0);
         TweenLite.from(this.tree1_image,2,{"y":this.tree1_image.y - 165});
         TweenLite.from(this.tree2_image,2,{"y":this.tree2_image.y - 165});
         TweenLite.from(this.tree3_image,2,{"y":this.tree3_image.y + 40});
         TweenLite.from(this.tree4_image,2,{"y":this.tree4_image.y + 40});
         TweenLite.from(this.tree5_image,2,{"y":this.tree5_image.y + 110});
         TweenLite.from(this.tree6_image,2,{"y":this.tree6_image.y + 110});
         TweenLite.from(this.woodPlatform_image,2,{"y":this.woodPlatform_image.y + 200});
         this.leftPersonClone = new Person(_gameMain,false,"");
         this.leftPersonClone.x = -337;
         this.leftPersonClone.y = -92;
         addChildAt(this.leftPersonClone,0);
         this.rightPersonClone = new Person(_gameMain,false,"");
         this.rightPersonClone.x = -60;
         this.rightPersonClone.y = -92;
         this.rightPersonClone.scaleX = -2;
         addChildAt(this.rightPersonClone,0);
         this.personClone = new Person(_gameMain,false,"");
         this.personClone.x = -195;
         this.personClone.y = -85;
         this.personClone.bodyAnimator.shirtString = "white shirt";
         this.personClone.bodyAnimator.pantsString = "green shorts";
         this.personClone.bodyAnimator.shoeString = "white shoe";
         addChildAt(this.personClone,getChildIndex(nonChange_image) - 1);
         TweenLite.from(this.personClone,2,{"y":this.personClone.y + 200});
         this.rightPersonClone.touchable = this.leftPersonClone.touchable = this.personClone.touchable = false;
         this.rightPersonClone.scaleY = this.leftPersonClone.scaleX = this.leftPersonClone.scaleY = 2;
         colorFilter = new ColorMatrixFilter();
         colorFilter.tint(16777215,0.8);
         this.leftPersonClone.filter = new FilterChain(colorFilter);
         this.rightPersonClone.filter = new FilterChain(colorFilter);
         this.setCharCreateExample(this.leftPersonClone,"warrior1");
         this.setCharCreateExample(this.rightPersonClone,"warrior2");
         addEventListener(Event.ENTER_FRAME,this.onEnter);
      }
      
      public function classLeft() : void
      {
         switch(this.class_txt.text)
         {
            case "warrior":
               this.personClone.bodyAnimator.weaponString = "airsoft gun";
               this.class_txt.text = "cowboy";
               break;
            case "mage":
               this.personClone.bodyAnimator.weaponString = "stick";
               this.class_txt.text = "warrior";
               break;
            case "archer":
               this.personClone.bodyAnimator.weaponString = "basic wand";
               this.class_txt.text = "mage";
               break;
            case "cowboy":
               this.personClone.bodyAnimator.weaponString = "slingshot";
               this.class_txt.text = "archer";
         }
         this.setCharCreateExample(this.leftPersonClone,this.class_txt.text + "1");
         this.setCharCreateExample(this.rightPersonClone,this.class_txt.text + "2");
      }
      
      public function classRight() : void
      {
         switch(this.class_txt.text)
         {
            case "warrior":
               this.personClone.bodyAnimator.weaponString = "basic wand";
               this.class_txt.text = "mage";
               break;
            case "mage":
               this.personClone.bodyAnimator.weaponString = "slingshot";
               this.class_txt.text = "archer";
               break;
            case "archer":
               this.personClone.bodyAnimator.weaponString = "airsoft gun";
               this.class_txt.text = "cowboy";
               break;
            case "cowboy":
               this.personClone.bodyAnimator.weaponString = "stick";
               this.class_txt.text = "warrior";
         }
         this.setCharCreateExample(this.leftPersonClone,this.class_txt.text + "1");
         this.setCharCreateExample(this.rightPersonClone,this.class_txt.text + "2");
      }
      
      public function changeGender() : void
      {
         if(this.gender_txt.text == "boy")
         {
            this.personClone.bodyAnimator.gender = "female";
            this.personClone.bodyAnimator.hair = 11;
            this.personClone.bodyAnimator.beard = 1;
            this.personClone.bodyAnimator.eyes = 7;
            this.beard_txt.text = this.personClone.bodyAnimator.beardString;
            this.hair_txt.text = "blonde tails";
            this.beardLeft_btn.visible = this.beardRight_btn.visible = false;
            this.gender_txt.text = "girl";
         }
         else
         {
            this.personClone.bodyAnimator.gender = "male";
            this.personClone.bodyAnimator.hair = 1;
            this.personClone.bodyAnimator.eyes = 1;
            this.beard_txt.text = this.personClone.bodyAnimator.beardString;
            this.hair_txt.text = "brown";
            this.beardLeft_btn.visible = this.beardRight_btn.visible = true;
            this.gender_txt.text = "boy";
         }
         this.personClone.bodyAnimator.skin = 1;
         this.eyes_txt.text = this.personClone.bodyAnimator.eyesString;
         this.skin_txt.text = this.personClone.bodyAnimator.skinString;
      }
      
      public function hairLeft() : void
      {
         if(this.personClone.bodyAnimator.hair == 1)
         {
            this.personClone.bodyAnimator.hair = 26;
         }
         else
         {
            --this.personClone.bodyAnimator.hair;
         }
         if(this.gender_txt.text == "boy")
         {
            if(this.personClone.bodyAnimator.hair == 16)
            {
               this.personClone.bodyAnimator.hair = 10;
            }
            else if(this.personClone.bodyAnimator.hair == 23)
            {
               this.personClone.bodyAnimator.hair = 20;
            }
         }
         else
         {
            if(this.personClone.bodyAnimator.hair == 10)
            {
               this.personClone.bodyAnimator.hair = 23;
            }
            if(this.personClone.bodyAnimator.hair == 20)
            {
               this.personClone.bodyAnimator.hair = 15;
            }
         }
         this.hair_txt.text = this.personClone.bodyAnimator.hairString;
      }
      
      public function hairRight() : void
      {
         if(this.gender_txt.text == "girl" && this.personClone.bodyAnimator.hair == 23)
         {
            this.personClone.bodyAnimator.hair = 11;
         }
         else if(this.personClone.bodyAnimator.hair == 26)
         {
            this.personClone.bodyAnimator.hair = 1;
         }
         else
         {
            ++this.personClone.bodyAnimator.hair;
         }
         if(this.gender_txt.text == "boy")
         {
            if(this.personClone.bodyAnimator.hair == 11)
            {
               this.personClone.bodyAnimator.hair = 17;
            }
            else if(this.personClone.bodyAnimator.hair == 21)
            {
               this.personClone.bodyAnimator.hair = 24;
            }
         }
         else if(this.personClone.bodyAnimator.hair == 16)
         {
            this.personClone.bodyAnimator.hair = 21;
         }
         this.hair_txt.text = this.personClone.bodyAnimator.hairString;
      }
      
      public function eyesLeft() : void
      {
         if(this.gender_txt.text == "boy")
         {
            if(this.personClone.bodyAnimator.eyes == 1)
            {
               this.personClone.bodyAnimator.eyes = 6;
            }
            else
            {
               --this.personClone.bodyAnimator.eyes;
            }
         }
         else if(this.personClone.bodyAnimator.eyes == 7)
         {
            this.personClone.bodyAnimator.eyes = 12;
         }
         else
         {
            --this.personClone.bodyAnimator.eyes;
         }
         this.eyes_txt.text = this.personClone.bodyAnimator.eyesString;
      }
      
      public function eyesRight() : void
      {
         if(this.gender_txt.text == "boy")
         {
            if(this.personClone.bodyAnimator.eyes < 6)
            {
               ++this.personClone.bodyAnimator.eyes;
            }
            else
            {
               this.personClone.bodyAnimator.eyes = 1;
            }
         }
         else if(this.personClone.bodyAnimator.eyes < 12)
         {
            ++this.personClone.bodyAnimator.eyes;
         }
         else
         {
            this.personClone.bodyAnimator.eyes = 7;
         }
         this.eyes_txt.text = this.personClone.bodyAnimator.eyesString;
      }
      
      public function skinLeft() : void
      {
         if(this.personClone.bodyAnimator.skin > 1)
         {
            --this.personClone.bodyAnimator.skin;
         }
         else
         {
            this.personClone.bodyAnimator.skin = 4;
         }
         this.skin_txt.text = this.personClone.bodyAnimator.skinString;
      }
      
      public function skinRight() : void
      {
         if(this.personClone.bodyAnimator.skin < 4)
         {
            ++this.personClone.bodyAnimator.skin;
         }
         else
         {
            this.personClone.bodyAnimator.skin = 1;
         }
         this.skin_txt.text = this.personClone.bodyAnimator.skinString;
      }
      
      public function beardLeft() : void
      {
         if(this.personClone.bodyAnimator.beard > 1)
         {
            --this.personClone.bodyAnimator.beard;
         }
         else
         {
            this.personClone.bodyAnimator.beard = 8;
         }
         this.beard_txt.text = this.personClone.bodyAnimator.beardString;
      }
      
      public function beardRight() : void
      {
         if(this.personClone.bodyAnimator.beard < 8)
         {
            ++this.personClone.bodyAnimator.beard;
         }
         else
         {
            this.personClone.bodyAnimator.beard = 1;
         }
         this.beard_txt.text = this.personClone.bodyAnimator.beardString;
      }
      
      private function setCharCreateExample(param1:Person, param2:String) : void
      {
         var _loc3_:String = null;
         param1.alpha = 1;
         TweenMax.from(param1,0.8,{
            "alpha":0,
            "ease":Linear.easeNone
         });
         var _loc4_:int = 1;
         switch(param2)
         {
            case "warrior1":
               param1.bodyAnimator.helmetString = "helmet of hatred";
               param1.bodyAnimator.shirtString = "armor of hatred";
               param1.bodyAnimator.pantsString = "legs of hatred";
               param1.bodyAnimator.weaponString = "single hatred blade";
               param1.bodyAnimator.weapon2String = "single hatred blade";
               param1.bodyAnimator.shoeString = "imperial boot";
               break;
            case "warrior2":
               param1.bodyAnimator.helmetString = "knight helmet";
               param1.bodyAnimator.shirtString = "knight armor";
               param1.bodyAnimator.pantsString = "knight armor legs";
               param1.bodyAnimator.weaponString = "teardrop blade";
               param1.bodyAnimator.weapon2String = "none";
               param1.bodyAnimator.shoeString = "steel boot";
               break;
            case "archer1":
               param1.bodyAnimator.helmetString = "archer hat";
               param1.bodyAnimator.shirtString = "archer shirt";
               param1.bodyAnimator.pantsString = "archer pants";
               param1.bodyAnimator.weaponString = "triple leaf bow";
               param1.bodyAnimator.weapon2String = "none";
               param1.bodyAnimator.shoeString = "elf bell shoe";
               break;
            case "archer2":
               param1.bodyAnimator.helmetString = "strong basket helmet";
               param1.bodyAnimator.shirtString = "strong armor";
               param1.bodyAnimator.pantsString = "strong legs";
               param1.bodyAnimator.weaponString = "night glow bow";
               param1.bodyAnimator.weapon2String = "none";
               param1.bodyAnimator.shoeString = "double bell shoe";
               break;
            case "mage1":
               param1.bodyAnimator.helmetString = "blue wizard belt hat";
               param1.bodyAnimator.shirtString = "blue wizard robe";
               param1.bodyAnimator.pantsString = "blue wizard pants";
               param1.bodyAnimator.weaponString = "nightingale wand";
               param1.bodyAnimator.weapon2String = "star wand";
               param1.bodyAnimator.shoeString = "blue magic shoe";
               break;
            case "mage2":
               param1.bodyAnimator.helmetString = "neon magic helmet";
               param1.bodyAnimator.shirtString = "neon magic suit";
               param1.bodyAnimator.pantsString = "neon magic legs";
               param1.bodyAnimator.weaponString = "spherical staff";
               param1.bodyAnimator.weapon2String = "none";
               param1.bodyAnimator.shoeString = "element boot";
               break;
            case "cowboy1":
               param1.bodyAnimator.helmetString = "cowboy hat";
               param1.bodyAnimator.shirtString = "cowboy shirt";
               param1.bodyAnimator.pantsString = "cowboy pants";
               param1.bodyAnimator.weaponString = "shotgun";
               param1.bodyAnimator.weapon2String = "none";
               param1.bodyAnimator.shoeString = "brown shoe";
               break;
            case "cowboy2":
               param1.bodyAnimator.helmetString = "pirate hat";
               param1.bodyAnimator.shirtString = "pirate vest";
               param1.bodyAnimator.pantsString = "pirate pants";
               param1.bodyAnimator.weaponString = "skullcrusher gun";
               param1.bodyAnimator.weapon2String = "none";
               param1.bodyAnimator.shoeString = "skull crusher boot";
         }
         this.classTitle_txt.text = "The " + param2.substr(0,1).toUpperCase() + param2.substr(1,param2.length).toLowerCase();
         this.classTitle_txt.text = this.classTitle_txt.text.slice(0,this.classTitle_txt.text.length - 1);
         if(this.classItem != null)
         {
            this.classItem.removeFromParent(true);
         }
         switch(this.classTitle_txt.text)
         {
            case "The Warrior":
               _loc3_ = "beholder sword";
               this.classDesc_txt.text = "Warriors are focused towards power and defense.  They wear highly defensive armor allowing them to get up close and personal with enemies and deal large amounts of damage in a single blow.  The armor and helmets that warriors wear are often aggresive and fully protected for a high resistance to damage.   Warriors can dual weild, use shields, and make good use of large melee weapons.";
               break;
            case "The Archer":
               _loc3_ = "natures bow";
               this.classDesc_txt.text = "Archers are ideal for long distance attacks. Their bows allow them to hit enemies from across screen.  While their overall damage isn\'t quite as high as a warrior or mage, their attacking distance is unmatched.  Archers equipment is often crafted from natural materials such as leaves or green materials.  Their skills allow them to do things such as shoot multiple arrows at once or straight up into the air.";
               break;
            case "The Mage":
               _loc3_ = "blue sphere staff";
               this.classDesc_txt.text = "Mages can deal extremely high damage over a short period of time at the cost of using MP. While they deal less damage than a warrior in a single blow, their projectiles can hit multiple times. A mages projectiles allow them to make attacks without having to be directly next to an enemy. Although they have some range capabilities, they are not as well equipped as an archer for long distance attacks.";
               break;
            case "The Cowboy":
               _loc3_ = "M16";
               this.classDesc_txt.text = "Cowboys are masters of guns.  They deal very low damage per shot but are able to dish out several shots per second depending on their weapon.  Their attacking distance is better than a mage but just less than an archer\'s.  Special abilities include the ability to throw grenades and attack upwards.  Cowboys often wear pirate clothes or cowboy hats styled in brown or black outfits.";
         }
         this.classItem = new Item(_loc3_,"","");
         this.classItem.x = -278;
         this.classItem.y = 26;
         this.classItem.rotation = deg2rad(45);
         addChild(this.classItem);
      }
      
      public function setPlayerToClone(param1:Person) : void
      {
         param1.bodyAnimator.originalHair = this.personClone.bodyAnimator.hair;
         param1.bodyAnimator.eyes = this.personClone.bodyAnimator.eyes;
         param1.bodyAnimator.hair = this.personClone.bodyAnimator.hair;
         param1.bodyAnimator.beard = this.personClone.bodyAnimator.beard;
         param1.bodyAnimator.shirtFrame = this.personClone.bodyAnimator.shirtFrame;
         param1.bodyAnimator.pantsFrame = this.personClone.bodyAnimator.pantsFrame;
         param1.bodyAnimator.shoeString = this.personClone.bodyAnimator.shoeString;
         param1.bodyAnimator.skin = this.personClone.bodyAnimator.skin;
      }
      
      public function registerError(param1:PlayerIOError) : void
      {
         MainStarlingStage(root).gameMain.createAlert(param1.message);
         this.finished_btn.visible = true;
      }
      
      public function hideButtons() : void
      {
         this.classLeft_btn.visible = this.classRight_btn.visible = false;
         this.name_txt.isSelectable = this.password_txt.isSelectable = this.email_txt.isSelectable = false;
         this.genderLeft_btn.visible = this.genderRight_btn.visible = false;
         this.hairLeft_btn.visible = this.hairRight_btn.visible = false;
         this.eyesLeft_btn.visible = this.eyesRight_btn.visible = false;
         this.skinLeft_btn.visible = this.skinRight_btn.visible = false;
         this.beardLeft_btn.visible = this.beardRight_btn.visible = false;
      }
      
      private function onEnter(param1:Event) : void
      {
         this.personClone.bodyAnimator.onEnter();
         if(this.personClone.bodyAnimator.currentLabel != "standing")
         {
            this.personClone.bodyAnimator.gotoAndPlayInt(0);
         }
         this.leftPersonClone.bodyAnimator.onEnter();
         this.leftPersonClone.bodyAnimator.stop();
         this.rightPersonClone.bodyAnimator.onEnter();
         this.rightPersonClone.bodyAnimator.stop();
      }
   }
}

