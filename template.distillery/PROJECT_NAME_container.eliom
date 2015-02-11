(* This file was generated by Eliom-base-app.
   Feel free to use it, modify it, and redistribute it as you wish. *)

(** This module defines the default template for application pages *)

{shared{
  open Eliom_content.Html5
  open Eliom_content.Html5.F
}}

let uploader = Eba_userbox.uploader !%%%MODULE_NAME%%%_config.avatar_dir

{client{
let user_menu user uploader =
  [
    p [pcdata "Change your password:"];
    Eba_view.password_form ();
    hr ();
    Eba_userbox.upload_pic_link uploader;
    hr ();
    Eba_userbox.reset_tips_link ();
    hr ();
    Eba_view.disconnect_button ();
  ]

let _ = Eba_userbox.set_user_menu user_menu
 }}

let header ?user () =
  lwt user_box = Eba_userbox.userbox user uploader in
  lwt () = %%%MODULE_NAME%%%_tips.example_tip () in
  Lwt.return
    (header ~a:[a_id "main"] [
      a ~a:[a_id "%%%PROJECT_NAME%%%-logo"]
        ~service:Eba_services.main_service [
          pcdata %%%MODULE_NAME%%%_base.App.application_name;
        ] ();
      ul ~a:[a_id "%%%PROJECT_NAME%%%-navbar"]
        [
          li [a ~service:Eba_services.main_service
                [pcdata "Home"] ()];
          li [a ~service:%%%MODULE_NAME%%%_services.about_service
                [pcdata "About"] ()]
        ];
      user_box;
    ])

let footer ?user () =
  div ~a:[a_id "%%%PROJECT_NAME%%%-footer"] [
    pcdata "This application has been generated using the ";
    a ~service:Eba_services.eba_github_service [
      pcdata "Eliom-base-app"
    ] ();
    pcdata " template for Eliom-distillery and uses the ";
    a ~service:Eba_services.ocsigen_service [
      pcdata "Ocsigen"
    ] ();
    pcdata " technology.";
  ]

let connected_welcome_box () =
  let info, ((fn, ln), (p1, p2)) =
    match Eliom_reference.Volatile.get Eba_msg.wrong_pdata with
    | None ->
      p [
        pcdata "Your personal information has not been set yet.";
        br ();
        pcdata "Please take time to enter your name and to set a password."
      ], (("", ""), ("", ""))
    | Some wpd -> p [pcdata "Wrong data. Please fix."], wpd
  in
  (div ~a:[a_id "eba_welcome_box"]
     [
       div [h2 [pcdata ("Welcome!")];
            info];
       Eba_view.information_form
         ~firstname:fn ~lastname:ln
         ~password1:p1 ~password2:p2
         ()
     ])

let page userid_o content =
  lwt user = match userid_o with None -> Lwt.return None
    | Some userid -> lwt u = Eba_user.user_of_userid userid in
                  Lwt.return (Some u)
  in
  let l =
    [ div ~a:[a_id "%%%PROJECT_NAME%%%-body"] content;
      footer ?user ();
    ]
  in
  lwt h = header ?user () in
  Lwt.return
    (h
     ::match user with
       | Some user when (not (Eba_user.is_complete user)) ->
         connected_welcome_box () :: l
       | _ -> l)
