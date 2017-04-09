<?php

require './server/vendor/phpmailer/phpmailer/PHPMailerAutoload.php';

function sendMail($user, $link){
     $mail = new PHPMailer;
    $mail->isSendMail();    //For 1and1 hosting smtp disable                           
    $mail->Host = mailHost;  
    $mail->SMTPAuth = true;                              
    $mail->Username = mailUsername;                
    $mail->Password = mailPassword;                          
    $mail->SMTPSecure = 'tls';                           
    $mail->Port = 587;                                   

    $mail->setFrom(mailsetFrom, mailsetFromName);
    $mail->addAddress("$user", '');     

    $mail->isHTML(true);

    $mail->Subject = 'Here is the subject';
    $mail->Body    = "Por favor, sigue este link para verificar tu dirección de correo <a href='$link'>$link</a>";
    $mail->AltBody = "Por favor, sigue este link para verificar tu dirección de correo $link";

    if(!$mail->send()) {
        return false;
        echo 'Message could not be sent.';
        echo 'Mailer Error: ' . $mail->ErrorInfo;
    } else {
        return true;
        echo 'Message has been sent';
    }
}