/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.silkworm.automation;

/* 
 * Copyright 2005 - 2009 Terracotta, Inc. 
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not 
 * use this file except in compliance with the License. You may obtain a copy 
 * of the License at 
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0 
 *   
 * Unless required by applicable law or agreed to in writing, software 
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT 
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the 
 * License for the specific language governing permissions and limitations 
 * under the License.
 * 
 */
import com.silkworm.persistence.relational.UniqueIDGen;
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

/**
 * This Example will demonstrate how to start and shutdown the Quartz scheduler
 * and how to schedule a job to run in Quartz.
 *
 * @author Bill Kratzer
 */
public class CustomScheduler {

    private String id;
    private String groupName;
    private String triggerName;
    private String jobName;
    private Scheduler scheduler;
    private final Class<Job> customJob;
    private final long interval;

    private CustomScheduler(String id, Class customJob, long interval) {
        this.id = id;
        this.customJob = customJob;
        this.interval = interval;
    }

    private CustomScheduler(Class customJob, long interval) {
        this(null, customJob, interval);
    }

    /**
     * This function return new object from type CustomScheduler
     *
     * @param customJob represent class contains an implementation job
     * @param interval this value by seconds and represent time re-execute after
     * @return
     */
    public static CustomScheduler getInstance(Class customJob, long interval) {
        return new CustomScheduler(customJob, interval);
    }

    /**
     * This function return new object from type CustomScheduler
     *
     * @param id
     * @param customJob represent class contains an implementation job
     * @param interval this value by seconds and represent time re-execute after
     * @return
     */
    public static CustomScheduler getInstance(String id, Class customJob, long interval) {
        return new CustomScheduler(id, customJob, interval);
    }

    public void run() throws Exception {
        Logger log = LoggerFactory.getLogger(CustomScheduler.class);

        log.info("------- Initializing Job: " + customJob + " ----------------------");

        // First we must get a reference to a scheduler
        SchedulerFactory factory = new StdSchedulerFactory();
        scheduler = factory.getScheduler();

        log.info("------- Scheduling Job: " + customJob + " -------------------");
        JobBuilder jobBuilder = newJob(customJob);
        jobBuilder.withIdentity("myJob", "group" + UniqueIDGen.getNextID());
        JobDetail job = jobBuilder.build();

        // Trigger the job to run now, and then every 40 seconds
        TriggerBuilder triggerBuilder = newTrigger();
        triggerBuilder.withIdentity("myTrigger", "group" + UniqueIDGen.getNextID());
        triggerBuilder.startNow();
        triggerBuilder.withSchedule(simpleSchedule().withIntervalInSeconds((int) interval).repeatForever());
        Trigger trigger = triggerBuilder.build();

        // Tell quartz to schedule the job using our trigger
        scheduler.scheduleJob(job, trigger);
        scheduler.start();

        log.info("------- Scheduling start ok Job: " + customJob + " -------------------");
    }

    public void init(String[] keys, Object[] values) throws Exception {
        if (keys.length != values.length) {
            throw new Exception("Invalid keys(length: " + keys.length + ") and values(length: " + values.length + ")");
        }
        long identity = System.currentTimeMillis();
        groupName = "group@" + identity;
        triggerName = "trigger@" + identity;
        jobName = "job@" + identity;
        Logger log = LoggerFactory.getLogger(CustomScheduler.class);

        log.info("------- Initializing Job: " + customJob + " ----------------------");

        // First we must get a reference to a scheduler
        SchedulerFactory factory = new StdSchedulerFactory();
        scheduler = factory.getScheduler();

        log.info("------- Scheduling Job: " + customJob + " -------------------");
        JobBuilder builder = newJob(customJob);
        builder.withIdentity(jobName, groupName);
        Object value;
        for (int i = 0; i < values.length; i++) {
            value = values[i];
            if (value instanceof String) {
                builder.usingJobData(keys[i], (String) value);
            } else if (value instanceof Integer) {
                builder.usingJobData(keys[i], (Integer) value);
            } else if (value instanceof Double) {
                builder.usingJobData(keys[i], (Double) value);
            } else if (value instanceof Long) {
                builder.usingJobData(keys[i], (Long) value);
            } else if (value instanceof Float) {
                builder.usingJobData(keys[i], (Float) value);
            } else if (value instanceof Boolean) {
                builder.usingJobData(keys[i], (Boolean) value);
            }
        }
        JobDetail job = builder.build();

        // Trigger the job to run now, and then every 40 seconds
        TriggerBuilder triggerBuilder = newTrigger();
        triggerBuilder.withIdentity(triggerName, groupName);
        triggerBuilder.startNow();
        triggerBuilder.withSchedule(simpleSchedule().withIntervalInSeconds((int) interval).repeatForever());
        Trigger trigger = triggerBuilder.build();

        // Tell quartz to schedule the job using our trigger
        scheduler.scheduleJob(job, trigger);

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
