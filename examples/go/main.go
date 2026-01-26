package main

import (
	"fmt"

	pb "github.com/aminofox/zenc-protocol/generated/go"
)

func main() {
	fmt.Println("Zenc Protocol - Go Example")
	fmt.Println("===========================\n")

	// Create a join room request
	joinReq := &pb.JoinRoomRequest{
		RoomId: "room-123",
		UserId: "user-456",
		Role:   pb.RoomRole_ROOM_ROLE_PUBLISHER,
		Metadata: map[string]string{
			"name":   "Go User",
			"device": "desktop",
		},
	}

	fmt.Printf("Join Room Request:\n")
	fmt.Printf("  Room ID: %s\n", joinReq.RoomId)
	fmt.Printf("  User ID: %s\n", joinReq.UserId)
	fmt.Printf("  Role: %s\n", joinReq.Role)
	fmt.Printf("  Metadata: %v\n\n", joinReq.Metadata)

	// Create a track
	track := &pb.Track{
		Id:            "track-789",
		ParticipantId: "user-456",
		Kind:          pb.TrackKind_TRACK_KIND_VIDEO,
		Source:        pb.TrackSource_TRACK_SOURCE_CAMERA,
		Status:        pb.TrackStatus_TRACK_STATUS_ACTIVE,
		Quality:       pb.QualityLevel_QUALITY_LEVEL_HIGH,
	}

	fmt.Printf("Track:\n")
	fmt.Printf("  ID: %s\n", track.Id)
	fmt.Printf("  Kind: %s\n", track.Kind)
	fmt.Printf("  Source: %s\n", track.Source)
	fmt.Printf("  Status: %s\n", track.Status)
	fmt.Printf("  Quality: %s\n\n", track.Quality)

	// Create publish request
	publishReq := &pb.PublishTrackRequest{
		ParticipantId: "user-456",
		Track:         track,
		SdpOffer:      "v=0\r\no=- 123456 2 IN IP4 127.0.0.1\r\n...",
	}

	fmt.Printf("Publish Track Request:\n")
	fmt.Printf("  Participant ID: %s\n", publishReq.ParticipantId)
	fmt.Printf("  Track ID: %s\n", publishReq.Track.Id)
	fmt.Printf("  SDP Offer: %s...\n\n", publishReq.SdpOffer[:30])

	// Create an error
	err := &pb.Error{
		Code:    pb.ErrorCode_ERROR_CODE_NOT_FOUND,
		Message: "Room not found",
		Details: map[string]string{
			"room_id": "room-123",
		},
	}

	fmt.Printf("Error:\n")
	fmt.Printf("  Code: %s\n", err.Code)
	fmt.Printf("  Message: %s\n", err.Message)
	fmt.Printf("  Details: %v\n", err.Details)
}
