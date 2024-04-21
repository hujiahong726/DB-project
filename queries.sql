-- -- sign up
-- -- user 1 live in block 1; users 2, 3 live in block 2; users 4, 5 live in block 3
-- INSERT INTO Users (UserName, Password, Address, Latitude, Longitude, Profile, Photo)
-- VALUES 
--     ('alice123', 'p@ssw0rd', '789 Oak St, City, Country', 37.7742, -122.4178, 'Reader', NULL),
--     ('bob456', 'qwerty', '321 Pine St, City, Country', 34.0517, -118.2452, 'Writer.', NULL),
--     ('charlie789', 'letmein', '555 Maple St, City, Country', 34.0532, -118.2414, 'Student.', NULL),
--     ('diana101', 'password123', '999 Elm St, City, Country', 40.7106, -74.0066, 'Athlete.', NULL),
--     ('emma202', '123456', '777 Walnut St, City, Country', 40.7144, -74.0080, 'Dancer.', NULL);

-- -- Inserting data into Neighborhoods
-- INSERT INTO Neighborhoods (Name) VALUES ('Neighborhood 1'), ('Neighborhood 2');

-- -- Inserting data into Blocks
-- -- Assuming Neighborhood 1 has ID 1 and Neighborhood 2 has ID 2
-- INSERT INTO Blocks (Name, CenterLatitude, CenterLongitude, Radius, NeighborhoodID) VALUES 
-- ('Block 1', 37.7749, -122.4194, 1.00, 1), -- Block 1 in Neighborhood 1
-- ('Block 2', 34.0522, -118.2437, 1.00, 1), -- Block 2 in Neighborhood 1
-- ('Block 3', 40.7128, -74.0060, 2.00, 2); -- Block 3 in Neighborhood 2

-- -- apply to become members of a block
-- INSERT INTO BlockRequests (SenderID, BlockID, ApprovedCount) VALUES (1, 1, 0);

-- -- edit profiles
-- UPDATE Users
-- SET Profile = 'Leader'
-- WHERE UserID = 1;




-- content posting
-- initial message
-- Start a thread by posting a message from userid 1 to userid 2, as friend
INSERT INTO Threads (LocationLatitude, LocationLongitude, RecipientID, Target)
VALUES (0, 0, 2, 'friend');
INSERT INTO Messages (ThreadID, Title, AuthorID, Timestamp, Body)
VALUES (currval('Threads_ThreadID_seq'), 'War in Gaza', 1, CURRENT_TIMESTAMP, 'This is a friendly message');

-- Start another thread by posting another message from userid 2 to userid 3, as neighbor
INSERT INTO Threads (LocationLatitude, LocationLongitude, RecipientID, Target)
VALUES (0, 0, 3, 'neighbor');
INSERT INTO Messages (ThreadID, Title, AuthorID, Timestamp, Body)
VALUES (currval('Threads_ThreadID_seq'), 'Hello', 2, CURRENT_TIMESTAMP, 'This is a neighborly message');





