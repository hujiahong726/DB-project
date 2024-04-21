CREATE TABLE Users (
    UserID SERIAL PRIMARY KEY,
    UserName VARCHAR(100),
    Password VARCHAR(100),
    Address VARCHAR(255),
    Latitude DECIMAL(9,6),
    Longitude DECIMAL(9,6),
    Profile TEXT,
    Photo BYTEA
);

CREATE TABLE UserActivity (
    UserID INT REFERENCES Users(UserID),
    LastAccessTimestamp TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Neighborhoods (
    NeighborhoodID SERIAL PRIMARY KEY,
    Name VARCHAR(100)
);

CREATE TABLE Blocks (
    BlockID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    CenterLatitude DECIMAL(9,6),
    CenterLongitude DECIMAL(9,6),
    Radius DECIMAL(5,2),
    NeighborhoodID INT REFERENCES Neighborhoods(NeighborhoodID)
);

CREATE TABLE UserBlocks (
    UserID INT REFERENCES Users(UserID),
    BlockID INT REFERENCES Blocks(BlockID),
    IsJoined BOOLEAN,
    PRIMARY KEY (UserID, BlockID)
);

CREATE TABLE BlockRequests (
    RequestID SERIAL PRIMARY KEY,
    SenderID INT REFERENCES Users(UserID),
    BlockID INT REFERENCES Blocks(BlockID),
    ApprovedCount INT
);

CREATE TABLE RequestApprovals (
    ApprovalID SERIAL PRIMARY KEY,
    RequestID INT REFERENCES BlockRequests(RequestID),
    ApproverID INT REFERENCES Users(UserID),
    UNIQUE(RequestID, ApproverID)
);

CREATE TABLE UserFriends (
    UserID1 INT,
    UserID2 INT,
    FOREIGN KEY (UserID1) REFERENCES Users(UserID),
    FOREIGN KEY (UserID2) REFERENCES Users(UserID),
    PRIMARY KEY (UserID1, UserID2)
);

CREATE TYPE status AS ENUM ('PENDING', 'ACCEPTED', 'REJECTED');

CREATE TABLE FriendRequests (
    RequestID SERIAL PRIMARY KEY,
    SenderID INT REFERENCES Users(UserID),
    ReceiverID INT REFERENCES Users(UserID),
    RequestStatus status
);

CREATE TABLE UserNeighbors (
    UserID1 INT,
    UserID2 INT,
    FOREIGN KEY (UserID1) REFERENCES Users(UserID),
    FOREIGN KEY (UserID2) REFERENCES Users(UserID),
    PRIMARY KEY (UserID1, UserID2)
);

CREATE TYPE target AS ENUM ('friend', 'neighbor', 'hood', 'block');

CREATE TABLE Threads (
    ThreadID SERIAL PRIMARY KEY,
    LocationLatitude DECIMAL(9,6),
    LocationLongitude DECIMAL(9,6),
	RecipientID INT REFERENCES Users(UserID),
	Target target
);

CREATE TABLE Messages (
    MessageID SERIAL PRIMARY KEY,
    ThreadID INT REFERENCES Threads(ThreadID),
    Title VARCHAR(255),
    AuthorID INT REFERENCES Users(UserID),
    Timestamp TIMESTAMP,
    Body TEXT
);


