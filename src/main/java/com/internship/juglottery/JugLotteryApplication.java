package com.internship.juglottery;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class JugLotteryApplication {

    @Value("${DATA_SOURCE_URL}")
    private static String DATA_SOURCE_URL;

    public static void main(String[] args) {
        SpringApplication.run(JugLotteryApplication.class, args);
        System.out.println("###############################");
        System.out.println("###############################");
        System.out.println("###############################");
        System.out.println("###############################");
        System.out.println(DATA_SOURCE_URL);
    }

}
