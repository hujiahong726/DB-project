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




-- -- content posting
-- -- Start a thread from userid 1 to userid 2
-- INSERT INTO Threads (Title, LocationLatitude, LocationLongitude, RecipientID, Target)
-- VALUES ('Economy', 0, 0, 2, 'friend');
-- INSERT INTO Messages (ThreadID, AuthorID, Timestamp, Body)
-- VALUES (currval('Threads_ThreadID_seq'), 1, CURRENT_TIMESTAMP, 'The economy is recovering');

-- -- Start a thread from userid 2 to userid 3
-- INSERT INTO Threads (Title, LocationLatitude, LocationLongitude, RecipientID, Target)
-- VALUES ('Discount', 34.053233, -118.241670, 3, 'neighbor');
-- INSERT INTO Messages (ThreadID, AuthorID, Timestamp, Body)
-- VALUES (currval('Threads_ThreadID_seq'), 2, CURRENT_TIMESTAMP, 'Discount at the local deli');

-- -- replies
-- INSERT INTO Messages (ThreadID, AuthorID, Timestamp, Body)
-- VALUES (2, 3, CURRENT_TIMESTAMP, '@bob456. Heading over right now');




-- -- add friends
-- -- INSERT INTO FriendRequests(SenderID, ReceiverID, RequestStatus) VALUES(1, 5, 'PENDING');

-- -- approve friend request
-- -- Update the status of the request
-- UPDATE FriendRequests SET RequestStatus = 'ACCEPTED' WHERE SenderID = 1 AND ReceiverID = 5;

-- -- Insert a new entry into the UserFriends table
-- INSERT INTO UserFriends(UserID1, UserID2) VALUES(1, 5);

-- -- Delete the request from the FriendRequests table
-- DELETE FROM FriendRequests WHERE SenderID = 1 AND ReceiverID = 5 AND RequestStatus = 'ACCEPTED';

-- INSERT INTO userblocks (userid, blockid, isJoined) VALUES(2, 2, TRUE);
-- INSERT INTO userblocks (userid, blockid, isJoined) VALUES(3, 2, TRUE);
-- INSERT INTO userblocks (userid, blockid, isJoined) VALUES(4, 3, TRUE);
-- INSERT INTO userblocks (userid, blockid, isJoined) VALUES(5, 3, TRUE);

-- -- add neighbor
-- INSERT INTO userneighbors VALUES (2, 3);
-- INSERT INTO userneighbors VALUES (4, 5);

-- -- inserted data to test list all friends query
-- INSERT INTO UserFriends(UserID1, UserID2) VALUES(3, 1);

-- -- list all friends
-- SELECT Users.UserID, Users.UserName
-- FROM Users
-- JOIN UserFriends ON Users.UserID = CASE
--     WHEN UserFriends.UserID1 = 1 THEN UserFriends.UserID2
--     ELSE UserFriends.UserID1
--     END
-- WHERE UserFriends.UserID1 = 1 OR UserFriends.UserID2 = 1;

-- -- list all neighbors
-- SELECT Users.UserID, Users.UserName
-- FROM Users
-- JOIN UserNeighbors ON Users.UserID = UserNeighbors.UserID2
-- WHERE UserNeighbors.UserID1 = 2;





-- -- get messages
-- -- friend feed
-- SELECT Messages.MessageID, Messages.AuthorID, Messages.Body
-- FROM Messages
-- JOIN Threads ON Messages.ThreadID = Threads.ThreadID
-- WHERE Threads.RecipientID = 2
-- AND Threads.Target = 'friend';

-- -- neighbor feed
-- SELECT Threads.ThreadID, Messages.MessageID, Messages.AuthorID, Messages.Body
-- FROM Messages
-- JOIN Threads ON Messages.ThreadID = Threads.ThreadID
-- WHERE Threads.RecipientID = 3
-- AND Threads.Target = 'neighbor';

-- -- insert data to test block feed
-- INSERT INTO Threads (Title, LocationLatitude, LocationLongitude, RecipientID, Target)
-- VALUES ('Incident near Brooklyn Bridge', 40.712603, -74.005277, 3, 'block');
-- INSERT INTO Messages (ThreadID, AuthorID, Timestamp, Body)
-- VALUES (currval('Threads_ThreadID_seq'), 4, CURRENT_TIMESTAMP, 'Incident near Manhattan end of Brooklyn Bridge. Please be careful.');

-- INSERT INTO Threads (Title, LocationLatitude, LocationLongitude, RecipientID, Target)
-- VALUES ('Incident at Chambers Street Station', 40.714163, -74.008552, 3, 'block');
-- INSERT INTO Messages (ThreadID, AuthorID, Timestamp, Body)
-- VALUES (currval('Threads_ThreadID_seq'), 4, '2023-12-21 17:04:04.616445', 'Incident at Chambers Street Subway Station. Please be careful.');

-- INSERT INTO UserActivity (UserID, LastAccessTimestamp) VALUES (4, TIMESTAMP '2024-01-01 00:00:00');

-- -- block feed with new messages
-- SELECT Threads.ThreadID, Threads.Title, Threads.LocationLatitude, Threads.LocationLongitude,
--        Messages.MessageID, Messages.AuthorID, Messages.Timestamp, Messages.Body
-- FROM Threads
-- JOIN Messages ON Threads.ThreadID = Messages.ThreadID
-- JOIN UserBlocks ON Threads.RecipientID = UserBlocks.BlockID
-- JOIN UserActivity ON UserBlocks.UserID = UserActivity.UserID
-- WHERE UserBlocks.UserID = 4
-- AND Threads.Target = 'block'
-- AND Messages.Timestamp > UserActivity.LastAccessTimestamp;

-- -- old "incident" query
-- SELECT Threads.ThreadID, Threads.Title, Threads.LocationLatitude, Threads.LocationLongitude,
--        Messages.MessageID, Messages.AuthorID, Messages.Timestamp, Messages.Body
-- FROM Threads
-- JOIN Messages ON Threads.ThreadID = Messages.ThreadID
-- LEFT JOIN UserBlocks ON Threads.RecipientID = UserBlocks.BlockID
-- LEFT JOIN UserNeighbors ON Threads.RecipientID = 
-- WHERE (UserBlocks.UserID = 4 AND Threads.Target = 'block')
--    OR (UserNeighbors.UserID1 = 4 AND Threads.Target = 'hood')
--    OR (Threads.RecipientID = 4 AND (Threads.Target = 'friend' OR Threads.Target = 'neighbor' ))
--    AND (Messages.Body ILIKE '%incident%' OR Threads.Title ILIKE '%incident%');

SELECT Threads.ThreadID, Threads.Title, Threads.LocationLatitude, Threads.LocationLongitude,
       Messages.MessageID, Messages.AuthorID, Messages.Timestamp, Messages.Body
FROM Threads
JOIN Messages ON Threads.ThreadID = Messages.ThreadID
LEFT JOIN UserBlocks AS UB1 ON Threads.RecipientID = UB1.BlockID
LEFT JOIN (UserBlocks AS UB2 JOIN Blocks ON UB2.BlockID = Blocks.BlockID) 
			ON Threads.RecipientID = Blocks.NeighborhoodID
WHERE (UB1.UserID = 4 AND Threads.Target = 'block')
   OR (Threads.RecipientID = 4 AND Threads.Target = 'hood')
   OR (Threads.RecipientID = 4 AND (Threads.Target = 'friend' OR Threads.Target = 'neighbor' ))
   AND (Messages.Body ILIKE '%incident%' OR Threads.Title ILIKE '%incident%');

-- -- insert data to test location queries
-- INSERT INTO Threads (Title, LocationLatitude, LocationLongitude, RecipientID, Target)
-- VALUES ('Incident in Flushing', 40.761918, -73.830656, 3, 'block');
-- INSERT INTO Messages (ThreadID, AuthorID, Timestamp, Body)
-- VALUES (currval('Threads_ThreadID_seq'), 4, CURRENT_TIMESTAMP, 'Incident in Flushing. Please be careful.');

-- -- messages within 1 mile of where the user lives
-- SELECT Threads.ThreadID, Threads.Title, Threads.LocationLatitude, Threads.LocationLongitude,
--        Messages.MessageID, Messages.AuthorID, Messages.Timestamp, Messages.Body
-- FROM Threads
-- JOIN Users ON Threads.RecipientID = Users.UserID
-- JOIN Messages ON Threads.ThreadID = Messages.ThreadID
-- LEFT JOIN UserBlocks ON Threads.RecipientID = UserBlocks.BlockID
-- LEFT JOIN UserNeighbors ON Threads.RecipientID = UserNeighbors.UserID2
-- WHERE (UserBlocks.UserID = 5 AND Threads.Target = 'block')
--    OR (UserNeighbors.UserID1 = 5 AND Threads.Target = 'hood')
--    OR (Threads.RecipientID = 5 AND (Threads.Target = 'friend' OR Threads.Target = 'neighbor' ))
--    AND
--   		(ST_Distance(
--                ST_SetSRID(ST_MakePoint(CAST(Users.Latitude AS DOUBLE PRECISION), CAST(Users.Longitude AS DOUBLE PRECISION)), 4326),
--                ST_SetSRID(ST_MakePoint(CAST(Threads.LocationLatitude AS DOUBLE PRECISION), CAST(Threads.LocationLongitude AS DOUBLE PRECISION)), 4326)
--            ) * 0.000621371  -- Convert meters to miles
-- 	 <= 1)

-- -- Geographic search
-- -- Function for calculating distance from coordinates
-- CREATE OR REPLACE FUNCTION calculate_distance(lat1 float, lon1 float, lat2 float, lon2 float, units varchar)
-- RETURNS float AS $dist$
--     DECLARE
--         dist float = 0;
--         radlat1 float;
--         radlat2 float;
--         theta float;
--         radtheta float;
--     BEGIN
--         IF lat1 = lat2 AND lon1 = lon2
--             THEN RETURN dist;
--         ELSE
--             radlat1 = pi() * lat1 / 180;
--             radlat2 = pi() * lat2 / 180;
--             theta = lon1 - lon2;
--             radtheta = pi() * theta / 180;
--             dist = sin(radlat1) * sin(radlat2) + cos(radlat1) * cos(radlat2) * cos(radtheta);

--             IF dist > 1 THEN dist = 1; END IF;

--             dist = acos(dist);
--             dist = dist * 180 / pi();
--             dist = dist * 60 * 1.1515;

--             IF units = 'K' THEN dist = dist * 1.609344; END IF;
--             IF units = 'N' THEN dist = dist * 0.8684; END IF;

--             RETURN dist;
--         END IF;
--     END;
-- $dist$ LANGUAGE plpgsql;
-- WITH userHood AS (
-- 	SELECT userID, neighborhoodID
-- 	FROM userblocks u, blocks b
-- 	WHERE u.blockID = b.blockID),

-- allMessages AS (
-- 	SELECT threads.threadID, threads.LocationLatitude, threads.LocationLongitude
-- 	FROM threads 
-- 	JOIN messages m ON threads.threadID = m.threadID
-- 	LEFT JOIN userblocks ub ON threads.recipientID = ub.blockID
-- 	LEFT JOIN userHood uh  ON threads.recipientID = uh.neighborhoodID
-- 	WHERE (ub.userID = 4 AND threads.target = 'block')
-- 	OR (uh.userID = 4 AND threads.target='hood')
-- 	OR(threads.recipientID=4 AND (threads.target='friend' OR threads.target='neighbor'))),

-- userLocation AS (
-- 	SELECT Latitude, Longitude
-- 	FROM users
-- 	WHERE userID=4
-- ),

-- distanceCalculation AS (
-- 	SELECT allMessages.threadID, calculate_distance(allMessages.LocationLatitude, 
-- 													allMessages.LocationLongitude, 
-- 													userLocation.Latitude, 
-- 													userLocation.Longitude, 'M') as dist
-- 	FROM allMessages
-- 	JOIN userLocation ON TRUE
-- )

-- SELECT * FROM distanceCalculation WHERE dist<1;
