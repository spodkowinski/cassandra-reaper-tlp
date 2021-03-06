Feature: Using Reaper to launch repairs and schedule them

  ## TODO: clean-up and split the scenarios to be more like Given -> When -> Then [-> But]

  Background:
    Given cluster seed host "127.0.0.1" points to cluster with name "test_cluster"
    And ccm cluster "test_cluster" has keyspace "booya" with tables "booya1, booya2"
    And a real reaper service is running

  Scenario: Registering a cluster
    Given that we are going to use "127.0.0.1" as cluster seed host
    And reaper has no cluster in storage
    When an add-cluster request is made to reaper
    Then reaper has the last added cluster in storage
    When the last added cluster is deleted
    Then reaper has no longer the last added cluster in storage
    

  Scenario: Create a cluster and a scheduled repair run and delete them
    Given that we are going to use "127.0.0.1" as cluster seed host
    And reaper has no cluster in storage
    When an add-cluster request is made to reaper
    Then reaper has the last added cluster in storage
    And reaper has 0 scheduled repairs for the last added cluster
    When a new daily repair schedule is added for the last added cluster and keyspace "booya"
    Then reaper has 1 scheduled repairs for the last added cluster
    And deleting the last added cluster fails
    When the last added schedule is deleted for the last added cluster
    And the last added cluster is deleted
    Then reaper has no longer the last added cluster in storage
 
  Scenario: Create a cluster and a repair run and delete them
    Given that we are going to use "127.0.0.1" as cluster seed host
    And reaper has no cluster in storage
    When an add-cluster request is made to reaper
    Then reaper has the last added cluster in storage
    And reaper has 0 repairs for the last added cluster
    When a new repair is added for the last added cluster and keyspace "booya"
    And deleting the last added cluster fails
    And the last added repair is activated
    And we wait for at least 1 segments to be repaired
    Then reaper has 1 repairs for the last added cluster
    When the last added repair is stopped
    And the last added repair run is deleted
    And the last added cluster is deleted
    Then reaper has no longer the last added cluster in storage
    
  Scenario: Create a cluster and an incremental repair run and delete them
    Given that we are going to use "127.0.0.1" as cluster seed host
    And reaper has no cluster in storage
    When an add-cluster request is made to reaper
    Then reaper has the last added cluster in storage
    And reaper has 0 repairs for the last added cluster
    When a new incremental repair is added for the last added cluster and keyspace "booya"
    And deleting the last added cluster fails
    And the last added repair is activated
    And we wait for at least 1 segments to be repaired
    Then reaper has 1 repairs for the last added cluster
    When the last added repair is stopped
    And the last added repair run is deleted
    And the last added cluster is deleted
 