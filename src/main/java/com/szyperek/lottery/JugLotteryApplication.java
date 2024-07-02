package com.szyperek.lottery;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class JugLotteryApplication {

	public static void main(String[] args) {
		SpringApplication.run(JugLotteryApplication.class, args);
	}

}
