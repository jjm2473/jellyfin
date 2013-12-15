﻿
namespace MediaBrowser.Model.LiveTv
{
    public enum RecordingStatus
    {
        New,
        Scheduled,
        InProgress,
        Completed,
        Aborted,
        Cancelled,
        ConflictedOk,
        ConflictedNotOk,
        Error
    }

    public enum RecurrenceType
    {
        Manual,
        NewProgramEventsOneChannel,
        AllProgramEventsOneChannel,
        NewProgramEventsAllChannels,
        AllProgramEventsAllChannels
    }

    public enum DayPattern
    {
        Daily,
        Weekdays,
        Weekends
    }
}
