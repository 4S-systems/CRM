/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.silkworm.automation;

import java.util.Calendar;
import org.quartz.JobBuilder;
import static org.quartz.JobBuilder.newJob;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import static org.quartz.SimpleScheduleBuilder.simpleSchedule;
import org.quartz.Trigger;
import org.quartz.TriggerBuilder;
import static org.quartz.TriggerBuilder.newTrigger;
import org.quartz.impl.StdSchedulerFactory;

/**
 *
 * @author walid
 */
public class ClientEmailSmsSchedulerSingle extends CustomSchedulerSingle {

    public ClientEmailSmsSchedulerSingle(Class customJob) {
        super(customJob);
    }

    /**
     * This function return new object from type CustomScheduler
     *
     * @param customJob represent class contains an implementation job
     * @return
     */
    public static ClientEmailSmsSchedulerSingle getInstance(Class customJob) {
        return new ClientEmailSmsSchedulerSingle(customJob);
    }

    public void run(String email, String mobile) throws Exception {
        log.info("------- Initializing Job: " + customJob + " ----------------------");

        // First we must get a reference to a scheduler
        org.quartz.SchedulerFactory factory = new StdSchedulerFactory();
        Scheduler scheduler = factory.getScheduler();

        log.info("------- Scheduling Job: " + customJob + " -------------------");
        JobBuilder jobBuilder = newJob(customJob);
        jobBuilder.withIdentity(prefix + "Job", prefix + "Group");
        JobDetail job = jobBuilder.usingJobData("email", email).usingJobData("mobile", mobile).build();

        // Trigger the job to run now, and then every 40 seconds
        TriggerBuilder triggerBuilder = newTrigger();
        triggerBuilder.withIdentity(prefix + "Trigger", prefix + "Group");
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.SECOND, 4);
        triggerBuilder.startAt(calendar.getTime());
        triggerBuilder.withSchedule(simpleSchedule().withRepeatCount(0));
        Trigger trigger = triggerBuilder.build();

        // Tell quartz to schedule the job using our trigger
        scheduler.scheduleJob(job, trigger);
        scheduler.start();

        log.info("------- Scheduling start ok Job: " + customJob + " -------------------");
    }
}
