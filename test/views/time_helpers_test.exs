defmodule Tunedrop.TimeHelpersTest do
  use Tunedrop.ViewHelperCase
  use Timex

  test "returns time in words for now" do
    time = DateTime.now
    words = Tunedrop.TimeHelpers.distance_of_time_in_words(time)
    assert words =~ ~r/Less than 1 minute/
  end

  test "returns time in words for 30 minutes" do
    time = DateTime.shift(DateTime.now, minutes: 30)
    words = Tunedrop.TimeHelpers.distance_of_time_in_words(time)
    assert words =~ ~r/30 minutes/
  end

  test "returns time in words for 41 minutes" do
    time = DateTime.shift(DateTime.now, minutes: 41)
    words = Tunedrop.TimeHelpers.distance_of_time_in_words(time)
    assert words =~ ~r/41 minutes/
  end

  test "returns time in words for 90 minutes" do
    time = DateTime.shift(DateTime.now, minutes: 90)
    words = Tunedrop.TimeHelpers.distance_of_time_in_words(time)
    assert words =~ ~r/about 1 hour/
  end

  test "returns time in words for 91 minutes" do
    time = DateTime.shift(DateTime.now, minutes: 91)
    words = Tunedrop.TimeHelpers.distance_of_time_in_words(time)
    assert words =~ ~r/about 2 hours/
  end

  test "returns time in words for 1000 minutes" do
    time = DateTime.shift(DateTime.now, minutes: 1000)
    words = Tunedrop.TimeHelpers.distance_of_time_in_words(time)
    assert words =~ ~r/about 17 hours/
  end

  test "returns time in words for 1500 minutes" do
    time = DateTime.shift(DateTime.now, minutes: 1500)
    words = Tunedrop.TimeHelpers.distance_of_time_in_words(time)
    assert words =~ ~r/about 1 day/
  end

  test "returns time in words for 2521 minutes" do
    time = DateTime.shift(DateTime.now, minutes: 2521)
    words = Tunedrop.TimeHelpers.distance_of_time_in_words(time)
    assert words =~ ~r/about 2 days/
  end

  test "returns time in words for 43201 minutes" do
    time = DateTime.shift(DateTime.now, minutes: 43201)
    words = Tunedrop.TimeHelpers.distance_of_time_in_words(time)
    assert words =~ ~r/about 1 months/
  end

  test "returns time in words for 86400 minutes" do
    time = DateTime.shift(DateTime.now, minutes: 86400)
    words = Tunedrop.TimeHelpers.distance_of_time_in_words(time)
    assert words =~ ~r/2 months/
  end

  test "returns time in words for 525600 minutes" do
    time = DateTime.shift(DateTime.now, minutes: 525600)
    words = Tunedrop.TimeHelpers.distance_of_time_in_words(time)
    assert words =~ ~r/12 months/
  end

  test "returns time in words for 525601 minutes" do
    time = DateTime.shift(DateTime.now, minutes: 525601)
    words = Tunedrop.TimeHelpers.distance_of_time_in_words(time)
    assert words =~ ~r/a long time/
  end
end
