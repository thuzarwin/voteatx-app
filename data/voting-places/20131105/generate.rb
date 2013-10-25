#!/usr/bin/env -- ruby

require 'rubygems'
require 'bundler'
Bundler.setup
require "#{Bundler.root}/lib/voteatx/loader.rb"

raise "usage: #{$0} database\n" unless ARGV.length == 1
dbname = ARGV[0]
raise "database file \"#{dbname}\" does not exist\n" unless File.exist?(dbname)
loader = VoteATX::Loader.new(dbname, :log => @log, :debug => false)

loader.election_description = "for the Nov 5, 2013 general election in Travis County"

loader.election_info = %q{<b>Note:</b> Voting centers are in effect for this election.  That means on election day you can vote at <em>any</em> open Travis County polling place, not just your home precinct.

<i>(<a href="http://www.traviscountyclerk.org/eclerk/Content.do?code=E.4">more information ...</a>)</i>}

ELECTION_DAY_HOURS = Time.new(2013, 11, 5, 7, 0) .. Time.new(2013, 11, 5, 19, 0)

EARLY_VOTING_FIXED_HOURS = {

  'R' => [
    Time.new(2013, 10, 21,  7,  0) .. Time.new(2013, 10, 21, 19,  0), # Mo
    Time.new(2013, 10, 22,  7,  0) .. Time.new(2013, 10, 22, 19,  0), # Tu
    Time.new(2013, 10, 23,  7,  0) .. Time.new(2013, 10, 23, 19,  0), # We
    Time.new(2013, 10, 24,  7,  0) .. Time.new(2013, 10, 24, 19,  0), # Th
    Time.new(2013, 10, 25,  7,  0) .. Time.new(2013, 10, 25, 19,  0), # Fr
    Time.new(2013, 10, 26,  7,  0) .. Time.new(2013, 10, 26, 19,  0), # Sa
    Time.new(2013, 10, 27, 12,  0) .. Time.new(2013, 10, 27, 18,  0), # Su
    Time.new(2013, 10, 28,  7,  0) .. Time.new(2013, 10, 28, 19,  0), # Mo
    Time.new(2013, 10, 29,  7,  0) .. Time.new(2013, 10, 29, 19,  0), # Tu
    Time.new(2013, 10, 30,  7,  0) .. Time.new(2013, 10, 30, 19,  0), # We
    Time.new(2013, 10, 31,  7,  0) .. Time.new(2013, 10, 31, 19,  0), # Th
    Time.new(2013, 11,  1,  7,  0) .. Time.new(2013, 11,  1, 19,  0), # Fr
  ],

  # Mon – Wed 10 am – 5:30 pm, Thu 10 am – 7 pm, Fri 10 am – 4:30 pm, Sat 10 am – 3:30 pm, Sun Closed
  'V1' => [
    Time.new(2013, 10, 21, 10,  0) .. Time.new(2013, 10, 21, 17, 30), # Mo
    Time.new(2013, 10, 22, 10,  0) .. Time.new(2013, 10, 22, 17, 30), # Tu
    Time.new(2013, 10, 23, 10,  0) .. Time.new(2013, 10, 23, 17, 30), # We
    Time.new(2013, 10, 24, 10,  0) .. Time.new(2013, 10, 24, 19,  0), # Th
    Time.new(2013, 10, 25, 10,  0) .. Time.new(2013, 10, 25, 16, 30), # Fr
    Time.new(2013, 10, 26, 10,  0) .. Time.new(2013, 10, 26, 16, 30), # Sa
    Time.new(2013, 10, 27,  0,  0) .. Time.new(2013, 10, 27,  0,  0), # Su (closed)
    Time.new(2013, 10, 28, 10,  0) .. Time.new(2013, 10, 28, 17, 30), # Mo
    Time.new(2013, 10, 29, 10,  0) .. Time.new(2013, 10, 29, 17, 30), # Tu
    Time.new(2013, 10, 30, 10,  0) .. Time.new(2013, 10, 30, 17, 30), # We
    Time.new(2013, 10, 31, 10,  0) .. Time.new(2013, 10, 31, 19,  0), # Th
    Time.new(2013, 11,  1, 10,  0) .. Time.new(2013, 11,  1, 16, 30), # Fr
  ],

  # Mon – Thu 10 am – 7 pm, Fri Closed, Sat 10 am – 4:30 pm, Sun 2 pm – 5:30 pm
  'V2' => [
    Time.new(2013, 10, 21, 10,  0) .. Time.new(2013, 10, 21, 19,  0), # Mo
    Time.new(2013, 10, 22, 10,  0) .. Time.new(2013, 10, 22, 19,  0), # Tu
    Time.new(2013, 10, 23, 10,  0) .. Time.new(2013, 10, 23, 19,  0), # We
    Time.new(2013, 10, 24, 10,  0) .. Time.new(2013, 10, 24, 19,  0), # Th
    Time.new(2013, 10, 25,  0,  0) .. Time.new(2013, 10, 25,  0,  0), # Fr (closed)
    Time.new(2013, 10, 26, 10,  0) .. Time.new(2013, 10, 26, 16, 30), # Sa
    Time.new(2013, 10, 27, 14,  0) .. Time.new(2013, 10, 27, 17, 30), # Su
    Time.new(2013, 10, 28, 10,  0) .. Time.new(2013, 10, 28, 19,  0), # Mo
    Time.new(2013, 10, 29, 10,  0) .. Time.new(2013, 10, 29, 19,  0), # Tu
    Time.new(2013, 10, 30, 10,  0) .. Time.new(2013, 10, 30, 19,  0), # We
    Time.new(2013, 10, 31, 10,  0) .. Time.new(2013, 10, 31, 19,  0), # Th
    Time.new(2013, 11,  1,  0,  0) .. Time.new(2013, 11,  1,  0,  0), # Fr (closed)
  ],

  # Mon – Thu 9 am – 7 pm, Fri 9 am – 6 pm, Sat 9 am – 4 pm, Sun Closed
  'V3' => [
    Time.new(2013, 10, 21,  9,  0) .. Time.new(2013, 10, 21, 19,  0), # Mo
    Time.new(2013, 10, 22,  9,  0) .. Time.new(2013, 10, 22, 19,  0), # Tu
    Time.new(2013, 10, 23,  9,  0) .. Time.new(2013, 10, 23, 19,  0), # We
    Time.new(2013, 10, 24,  9,  0) .. Time.new(2013, 10, 24, 19,  0), # Th
    Time.new(2013, 10, 25,  9,  0) .. Time.new(2013, 10, 25, 18,  0), # Fr
    Time.new(2013, 10, 26,  9,  0) .. Time.new(2013, 10, 26, 16,  0), # Sa
    Time.new(2013, 10, 27,  0,  0) .. Time.new(2013, 10, 27,  0,  0), # Su (closed)
    Time.new(2013, 10, 28,  9,  0) .. Time.new(2013, 10, 28, 19,  0), # Mo
    Time.new(2013, 10, 29,  9,  0) .. Time.new(2013, 10, 29, 19,  0), # Tu
    Time.new(2013, 10, 30,  9,  0) .. Time.new(2013, 10, 30, 19,  0), # We
    Time.new(2013, 10, 31,  9,  0) .. Time.new(2013, 10, 31, 19,  0), # Th
    Time.new(2013, 11,  1,  9,  0) .. Time.new(2013, 11,  1, 18,  0), # Fr
  ],

  # Mon – Wed 10 am – 7 pm, Thu Closed, Fri 10 am – 5:30 pm, Sat 10 am – 4:30 pm, Sun Closed
  'V4' => [
    Time.new(2013, 10, 21, 10,  0) .. Time.new(2013, 10, 21, 19,  0), # Mo
    Time.new(2013, 10, 22, 10,  0) .. Time.new(2013, 10, 22, 19,  0), # Tu
    Time.new(2013, 10, 23, 10,  0) .. Time.new(2013, 10, 23, 19,  0), # We
    Time.new(2013, 10, 24,  0,  0) .. Time.new(2013, 10, 24,  0,  0), # Th (closed)
    Time.new(2013, 10, 25, 10,  0) .. Time.new(2013, 10, 25, 17, 30), # Fr
    Time.new(2013, 10, 26, 10,  0) .. Time.new(2013, 10, 26, 16, 30), # Sa
    Time.new(2013, 10, 27,  0,  0) .. Time.new(2013, 10, 27,  0,  0), # Su (closed)
    Time.new(2013, 10, 28, 10,  0) .. Time.new(2013, 10, 28, 19,  0), # Mo
    Time.new(2013, 10, 29, 10,  0) .. Time.new(2013, 10, 29, 19,  0), # Tu
    Time.new(2013, 10, 30, 10,  0) .. Time.new(2013, 10, 30, 19,  0), # We
    Time.new(2013, 10, 31,  0,  0) .. Time.new(2013, 10, 31,  0,  0), # Th (closed)
    Time.new(2013, 11,  1, 10,  0) .. Time.new(2013, 11,  1, 19,  0), # Fr
  ],

  # Mon – Thu 11 am – 7 pm, Fri 11 am – 6 pm, Sat 11 am – 5 pm, Sun Closed
  'V5' => [
    Time.new(2013, 10, 21, 11,  0) .. Time.new(2013, 10, 21, 19,  0), # Mo
    Time.new(2013, 10, 22, 11,  0) .. Time.new(2013, 10, 22, 19,  0), # Tu
    Time.new(2013, 10, 23, 11,  0) .. Time.new(2013, 10, 23, 19,  0), # We
    Time.new(2013, 10, 24, 11,  0) .. Time.new(2013, 10, 24, 19,  0), # Th
    Time.new(2013, 10, 25, 11,  0) .. Time.new(2013, 10, 25, 18,  0), # Fr
    Time.new(2013, 10, 26, 11,  0) .. Time.new(2013, 10, 26, 17,  0), # Sa
    Time.new(2013, 10, 27,  0,  0) .. Time.new(2013, 10, 27,  0,  0), # Su (closed)
    Time.new(2013, 10, 28, 11,  0) .. Time.new(2013, 10, 28, 19,  0), # Mo
    Time.new(2013, 10, 29, 11,  0) .. Time.new(2013, 10, 29, 19,  0), # Tu
    Time.new(2013, 10, 30, 11,  0) .. Time.new(2013, 10, 30, 19,  0), # We
    Time.new(2013, 10, 31, 11,  0) .. Time.new(2013, 10, 31, 19,  0), # Th
    Time.new(2013, 11,  1, 11,  0) .. Time.new(2013, 11,  1, 18,  0), # Fr
  ],

}

loader.valid_lng_range = -98.057163 .. -97.407671
loader.valid_lat_range = 30.088999 .. 30.572025

loader.create_tables
loader.load_eday_places("20131105_WEBLoad_G13_FINAL_EDay.csv", ELECTION_DAY_HOURS)
loader.load_evfixed_places("20131105_WEBLoad_G13_FINAL_EVPerm.csv", EARLY_VOTING_FIXED_HOURS)
loader.load_evmobile_places("20131105_WEBLoad_G13_FINAL_EVMobile.csv")
loader.log.info("done")

# vim:autoindent:shiftwidth=2:tabstop=2:expandtab