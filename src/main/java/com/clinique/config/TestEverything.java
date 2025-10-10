package com.clinique.config;

import org.mindrot.jbcrypt.BCrypt;

public class TestEverything {
    public static void main(String[] args) {
        System.out.println(BCrypt.hashpw("pass123", BCrypt.gensalt()));
    }
}