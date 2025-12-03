const express = require('express');
const cors = require('cors');
const { v4: uuidv4 } = require('uuid');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));

// In-memory database (for demo purposes)
let activities = [];

// Helper function to create response
const sendResponse = (res, statusCode, data) => {
  res.status(statusCode).json(data);
};

// Routes

// Health check
app.get('/api/health', (req, res) => {
  sendResponse(res, 200, { status: 'OK', message: 'SmartTracker API is running' });
});

// Get all activities
app.get('/api/activities', (req, res) => {
  const sortedActivities = [...activities].sort((a, b) =>
    new Date(b.timestamp) - new Date(a.timestamp)
  );
  sendResponse(res, 200, sortedActivities);
});

// Get single activity
app.get('/api/activities/:id', (req, res) => {
  const activity = activities.find(a => a.id === req.params.id);

  if (!activity) {
    return sendResponse(res, 404, { error: 'Activity not found' });
  }

  sendResponse(res, 200, activity);
});

// Create activity
app.post('/api/activities', (req, res) => {
  try {
    const { latitude, longitude, imageBase64, description } = req.body;

    // Validation
    if (!latitude || !longitude) {
      return sendResponse(res, 400, {
        error: 'Latitude and longitude are required'
      });
    }

    const newActivity = {
      id: uuidv4(),
      latitude: parseFloat(latitude),
      longitude: parseFloat(longitude),
      imageBase64: imageBase64 || null,
      description: description || null,
      timestamp: new Date().toISOString(),
      createdAt: new Date().toISOString(),
    };

    activities.push(newActivity);

    sendResponse(res, 201, newActivity);
  } catch (error) {
    console.error('Error creating activity:', error);
    sendResponse(res, 500, { error: 'Internal server error' });
  }
});

// Update activity
app.put('/api/activities/:id', (req, res) => {
  try {
    const index = activities.findIndex(a => a.id === req.params.id);

    if (index === -1) {
      return sendResponse(res, 404, { error: 'Activity not found' });
    }

    const { latitude, longitude, imageBase64, description } = req.body;

    activities[index] = {
      ...activities[index],
      latitude: latitude !== undefined ? parseFloat(latitude) : activities[index].latitude,
      longitude: longitude !== undefined ? parseFloat(longitude) : activities[index].longitude,
      imageBase64: imageBase64 !== undefined ? imageBase64 : activities[index].imageBase64,
      description: description !== undefined ? description : activities[index].description,
      updatedAt: new Date().toISOString(),
    };

    sendResponse(res, 200, activities[index]);
  } catch (error) {
    console.error('Error updating activity:', error);
    sendResponse(res, 500, { error: 'Internal server error' });
  }
});

// Delete activity
app.delete('/api/activities/:id', (req, res) => {
  const index = activities.findIndex(a => a.id === req.params.id);

  if (index === -1) {
    return sendResponse(res, 404, { error: 'Activity not found' });
  }

  activities.splice(index, 1);
  sendResponse(res, 200, { message: 'Activity deleted successfully' });
});

// Search activities
app.get('/api/activities/search', (req, res) => {
  const query = req.query.q?.toLowerCase() || '';

  if (!query) {
    return sendResponse(res, 400, { error: 'Search query is required' });
  }

  const results = activities.filter(activity =>
    activity.description?.toLowerCase().includes(query) ||
    activity.id.includes(query)
  );

  sendResponse(res, 200, results);
});

// Clear all activities (for testing)
app.delete('/api/activities', (req, res) => {
  activities = [];
  sendResponse(res, 200, { message: 'All activities cleared' });
});

// 404 handler
app.use((req, res) => {
  sendResponse(res, 404, { error: 'Route not found' });
});

// Error handler
app.use((err, req, res, next) => {
  console.error('Error:', err);
  sendResponse(res, 500, { error: 'Internal server error' });
});

// Start server
app.listen(PORT, () => {
  console.log(`SmartTracker API running on http://localhost:${PORT}`);
  console.log(`Health check: http://localhost:${PORT}/api/health`);
});

module.exports = app;