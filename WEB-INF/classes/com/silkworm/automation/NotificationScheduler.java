package com.silkworm.automation;

import org.quartz.Job;
import org.quartz.JobBuilder;
import static org.quartz.JobBuilder.newJob;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerFactory;
import org.quartz.Trigger;
import static org.quartz.TriggerBuilder.newTrigger;
import org.quartz.impl.StdSchedulerFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static org.quartz.SimpleScheduleBuilder.simpleSchedule;
import org.quartz.TriggerBuilder;

public class NotificationScheduler {

    private String id;
    private String groupName;
    private String triggerName;
    private String jobName;
    private Scheduler scheduler;
    private final Class<Job> customJob;
    private final long interval;

    private NotificationScheduler(String id, Class customJob, long interval) {
        this.id = id;
        this.customJob = customJob;
        this.interval = interval;
    }

    private NotificationScheduler(Class customJob, long interval) {
        this(null, customJob, interval);
    }

    public static NotificationScheduler getInstance(Class customJob, long interval) {
        return new NotificationScheduler(customJob, interval);
    }

    public static NotificationScheduler getInstance(String id, Class customJob, long interval) {
        return new NotificationScheduler(id, customJob, interval);
    }

    public void run() throws Exception {
        Logger log = LoggerFactory.getLogger(NotificationScheduler.class);

        log.info("------- Initializing Job: " + customJob + " ----------------------");
        long identity = System.currentTimeMillis();
        groupName = "group@" + identity;
        triggerName = "trigger@" + identity;
        jobName = "job@" + identity;
        // First we must get a reference to a scheduler
        SchedulerFactory factory = new StdSchedulerFactory();
        scheduler = factory.getScheduler();

        log.info("------- Scheduling Job: " + customJob + " -------------------");
        JobBuilder jobBuilder = newJob(customJob);
        jobBuilder.withIdentity(jobName, groupName);
        JobDetail job = jobBuilder.build();

        // Trigger the job to run now, and then every 40 seconds
        TriggerBuilder triggerBuilder = newTrigger();
        triggerBuilder.withIdentity(triggerName, groupName);
        triggerBuilder.startNow();
        triggerBuilder.withSchedule(simpleSchedule().withIntervalInSeconds((int) interval).repeatForever());
        Trigger trigger = triggerBuilder.build();

        // Tell quartz to schedule the job using our trigger
        scheduler.scheduleJob(job, trigger);
        scheduler.start();

        log.info("------- Scheduling start ok Job: " + customJob + " -------------------");
    }

    public Scheduler getScheduler() {
        return scheduler;
    }

    public String getId() {
        return id;
    }

    public String getJobName() {
        return jobName;
    }

    public String getTriggerName() {
        return triggerName;
    }

    public String getGroupName() {
        return groupName;
    }
}
