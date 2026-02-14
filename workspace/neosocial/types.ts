export interface User {
  id: string;
  name: string;
  handle: string;
  avatar: string;
  bio?: string;
  joined?: string;
  stats?: {
    posts: number;
    followers: string;
    following: number;
  }
}

export interface Post {
  id: string;
  user: User;
  content: string;
  image?: string;
  timestamp: string;
  tags: string[];
  likes: number;
  comments: number;
}
