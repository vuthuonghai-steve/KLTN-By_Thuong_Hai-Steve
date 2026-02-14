import React from 'react';
import { HashRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { Layout } from './components/Layout';
import { Feed } from './pages/Feed';
import { Settings } from './pages/Settings';
import { Login } from './pages/Login';
import { Profile } from './pages/Profile';
import { Explore } from './pages/Explore';
import { CreatePost } from './pages/CreatePost';
import { ComponentsLibrary } from './pages/ComponentsLibrary';

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Layout />}>
          <Route index element={<Feed />} />
          <Route path="settings" element={<Settings />} />
          <Route path="profile" element={<Profile />} />
          <Route path="explore" element={<Explore />} />
          <Route path="create" element={<CreatePost />} />
          <Route path="components" element={<ComponentsLibrary />} />
          {/* Redirect any unknown route to login for simplicity in this demo */}
          <Route path="login" element={<Login />} />
          <Route path="*" element={<Navigate to="/" replace />} />
        </Route>
      </Routes>
    </Router>
  );
}

export default App;
