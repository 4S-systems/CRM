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
public class CustomSchedulerSingle {

    protected final Class<Job> customJob;
    protected Logger log = LoggerFactory.getLogger(CustomSchedulerSingle.class);
    protected String prefix = "CustomSchedulerSingle";

    protected CustomSchedulerSingle(Class customJob) {
        this.customJob = customJob;
    }

    /**
     * This function return new object from type CustomScheduler
     *
     * @param customJob represent class contains an implementation job
     * @return
     */
    public static CustomSchedulerSingle getInstance(Class customJob) {
        return new CustomSchedulerSingle(customJob);
    }

    public void run() throws Exception {
        Scheduler scheduler = getScheduler();
        scheduler.start();

        log.info("------- Scheduling start ok Job: " + customJob + " -------------------");
    }

    protected Scheduler getScheduler() throws Exception {
        log.info("------- Initializing Job: " + customJob + " ----------------------");

        // First we must get a reference to a scheduler
        SchedulerFactory factory = new StdSchedulerFactory();
        Scheduler scheduler = factory.getScheduler();

        log.info("------- Scheduling Job: " + customJob + " -------------------");
        JobBuilder jobBuilder = newJob(customJob);
        jobBuilder.withIdentity(prefix + "Job", prefix + "Group");
        JobDetail job = jobBuilder.build();

        // Trigger the job to run now, and then every 40 seconds
        TriggerBuilder triggerBuilder = newTrigger();
        triggerBuilder.withIdentity(prefix + "Trigger", prefix + "Group");
        triggerBuilder.startNow();
        triggerBuilder.withSchedule(simpleSchedule().withIntervalInSeconds(1).repeatForever());
        Trigger trigger = triggerBuilder.build();

        // Tell quartz to schedule the job using our trigger
        scheduler.scheduleJob(job, trigger);

        return scheduler;
    }
}
